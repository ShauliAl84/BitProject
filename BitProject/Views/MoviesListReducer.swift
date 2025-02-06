//
//  MoviesListReducer.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import Foundation
import ComposableArchitecture
import SwiftData


struct MoviesListReducer: Reducer {
    @Dependency(\.apiClient) var apiClient
    
    @MainActor
    func saveMoviesIfNeeded(modelContext: ModelContext?, movies: [MovieDataModel], selectedCategory: MovieCategory) -> IdentifiedArrayOf<PersistantMovieData> {
        var persistenMovies = IdentifiedArrayOf<PersistantMovieData>()
        for movie in movies {
            let persistentMovie = PersistantMovieData(isFavorite: false, category: selectedCategory, movieDataModel: movie)
            persistenMovies.append(persistentMovie)
        }
        var insertionCandidates = persistenMovies
        let fetchDescriptor = FetchDescriptor<PersistantMovieData>()
        
        if let storedMovies = try? modelContext?.fetch(fetchDescriptor) {
            for storedMovie in storedMovies {
                if let _ = insertionCandidates[id: storedMovie.id] {
                    insertionCandidates.remove(id: storedMovie.id)
                }
            }
        }
        print(persistenMovies)
        for newMovie in insertionCandidates {
            print("Shauli: New Movie inserted")
            modelContext?.insert(newMovie)
        }
        
        try? modelContext?.save()
        return persistenMovies
        
    }

    
    var body: some ReducerOf<MoviesListReducer> {
        Reduce { state, action in
            switch action {
            case .fetchFavoritesMovies(let modelContext):
                do {
                    let movies = try modelContext.fetch(FetchDescriptor<PersistantMovieData>())
                    let favoriteMovies = movies.filter {$0.isFavorite == true}
                    print(favoriteMovies)
                    state.favoritesMoviesList = IdentifiedArrayOf(uniqueElements: favoriteMovies)
                    
                } catch let error {
                    print("Failed fetching fav movies \(error.localizedDescription)")
                }
                return .none
            case .fetchMoviesFromLocalStorage(let modelContext, let selectedCategory):
                state.modelContext = modelContext
                var storedMovies = try? modelContext.fetch(FetchDescriptor<PersistantMovieData>())
                storedMovies = storedMovies?.filter {$0.category == selectedCategory.rawValue}
                return .send(.moviesResponse(IdentifiedArrayOf(uniqueElements: storedMovies ?? [])))
            case .toggleMovieFavorite(let movie):
                movie.isFavorite.toggle()
//                try? state.modelContext?.save()
                if movie.isFavorite {
                    state.favoritesMoviesList.append(movie)
                }else {
                    state.favoritesMoviesList.remove(movie)
                }
                return .none
            case .loadNextPage:
                state.page += 1
                var path = Endpoints.upcoming.path
                switch state.selectedCategory {
                case .upcoming:
                    path = Endpoints.upcoming.path
                case .topRated:
                    path = Endpoints.topRated.path
                case .nowPlaying:
                    path = Endpoints.nowPlaying.path
                }
                return .send(.fetchMoviesListFromPath(path: path, modelContext: state.modelContext))
            case .selectedMovie:
                return .none
                
            case .movieDetailsResponse(.success(let movieDetails)):
                state.shouldNavigateToMovieDetailsView = true
                state.selectedMovieItem = movieDetails
                return .none
            case .fetchMovieData(let movieId):
                let page = state.page
                return .run { send in
                    do {
                        if let url = URL(string: Endpoints.movieDetails(movieId).path),
                           let movieData = try await apiClient.fetchMovies(url, page) {
                            
                            let movieDetails = try JSONDecoder().decode(MovieDataModel.self, from: movieData)
                            await send(.movieDetailsResponse(.success(movieDetails)))
                        }
                    } catch let error {
                        await send(.movieDetailsResponse(.failure(error)))
                    }
                }
            case .fetchMoviesListFromPath(let path, let modelContext):
                state.modelContext = modelContext
                let page = state.page
                return .run { send in
                    do {
                        if let url = URL(string: path),
                           let fetchedMoviesData = try await apiClient.fetchMovies(url, page) {
                            print("movies downloaded")
                            let moviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: fetchedMoviesData)
                            await send(.saveMoviesLocally(.success(moviesResponse.results)))
                        }
                        
                    } catch let error {
                        await send(.saveMoviesLocally(.failure(error)))
                    }
                }
            case .categorySelected(let category):
                if state.selectedCategory != category {
                    state.moviesList = IdentifiedArrayOf<PersistantMovieData>()
                    state.page = 1
                }
                state.selectedCategory = category
                switch category {
                case .upcoming:
                    return .send(.fetchMoviesListFromPath(path: Endpoints.upcoming.path, modelContext: state.modelContext))
                case .topRated:
                    return .send(.fetchMoviesListFromPath(path: Endpoints.topRated.path, modelContext: state.modelContext))
                case .nowPlaying:
                    return .send(.fetchMoviesListFromPath(path: Endpoints.nowPlaying.path, modelContext: state.modelContext))
                }
            case .searchStarted(searchText: let searchText):
                let filterdList = state.moviesList.filter {$0.originalTitle.contains(searchText)}
                state.moviesList = filterdList
                return .none
            case .favoriteTapped(let movie):
                let path = Endpoints.favorite(movie.id).path
                return .run { send in
                    do {
                        let parameters = [
                            "media_type": "movie",
                            "media_id": movie.id,
                            "favorite": !movie.isFavorite
                        ]
                        if let url = URL(string: path),
                           let data = try await apiClient.addRemoveFavorite(url, parameters) {
                            
                            let favoriteResponse = try JSONDecoder().decode(FavoriteResponseModel.self, from: data)
                            if favoriteResponse.success == true {
                                await send(.toggleMovieFavorite(movie: movie))
                            }
                        }
                        
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            case .movieTapped(let movie):
                state.selectedMovie = MovieDetailsReducer.State(movie: movie)
                return .none
            case .moviesResponse(let movies):
                state.moviesList += IdentifiedArrayOf(uniqueElements: movies)
                return .none
            case .saveMoviesLocally(.success(let movies)):
                let modelContext = state.modelContext
                let selectedCategory = state.selectedCategory
                return .run { send in
                    let persistenMovies = await saveMoviesIfNeeded(modelContext: modelContext, movies: movies, selectedCategory: selectedCategory)
                    return await send(.moviesResponse(persistenMovies))
                }
            case .saveMoviesLocally(.failure(let error)):
                print(error.localizedDescription)
                return .none
            case .movieDetailsResponse(.failure(_)):
                return .none
            }
        }
        .ifLet(\.$selectedMovie, action: /Action.selectedMovie) {
            MovieDetailsReducer()
        }
    }
    
    struct State: Equatable {
        var moviesList = IdentifiedArrayOf<PersistantMovieData>()
        var favoritesMoviesList = IdentifiedArrayOf<PersistantMovieData>()
        var selectedCategory: MovieCategory = .upcoming
        var categoryTitel: String = "Filter By Category"
        let categoryFilter = [MovieCategory.upcoming, MovieCategory.topRated, MovieCategory.nowPlaying]
        var shouldNavigateToMovieDetailsView: Bool = false
        var selectedMovieId: MovieDataModel? = nil
        var movieTitleSearchText: String = ""
        var selectedMovieItem: MovieDataModel? = nil
        var page: Int = 1
        var modelContext: ModelContext?
        @PresentationState var selectedMovie: MovieDetailsReducer.State?
    }
    
    enum Action: Equatable {
        case categorySelected(category: MovieCategory)
        case searchStarted(searchText: String)
        case favoriteTapped(movie: PersistantMovieData)
        case movieTapped(movie: PersistantMovieData)
        case moviesResponse(IdentifiedArrayOf<PersistantMovieData>)
        case movieDetailsResponse(TaskResult<MovieDataModel>)
        case fetchMoviesListFromPath(path: String, modelContext: ModelContext?)
        case fetchMovieData(movieId: Int)
        case toggleMovieFavorite(movie: PersistantMovieData)
        case selectedMovie(PresentationAction<MovieDetailsReducer.Action>)
        case loadNextPage
        case saveMoviesLocally(TaskResult<[MovieDataModel]>)
        case fetchMoviesFromLocalStorage(ModelContext, MovieCategory)
        case fetchFavoritesMovies(ModelContext)
        
    }
    
}

enum MovieCategory: String {
    case upcoming = "Upcoming"
    case topRated = "Top Rated"
    case nowPlaying = "Now Playing"
}
