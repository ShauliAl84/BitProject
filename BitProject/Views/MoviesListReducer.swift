//
//  MoviesListReducer.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import Foundation
import ComposableArchitecture
import SwiftData

extension URL {
    static let upcomingMoviesListFileURL = Self.documentsDirectory.appending(component: "upcoming_movies.json")
    static let topRatedMoviesListFileURL = Self.documentsDirectory.appending(component: "topRated_movies.json")
    static let nowPlayingMoviesListFileURL = Self.documentsDirectory.appending(component: "nowPlaying_movies.json")
    static let favoritesMoviesListFileURL = Self.documentsDirectory.appending(component: "favorites_movies.json")
}


extension SharedKey where Self == FileStorageKey<IdentifiedArrayOf<MovieDataModel>>.Default {
    static var upcomingMoviesList: Self {Self[.fileStorage(.upcomingMoviesListFileURL), default: []] }
    static var topRatedMoviesList: Self {Self[.fileStorage(.topRatedMoviesListFileURL), default: []] }
    static var nowPlayingMoviesList: Self {Self[.fileStorage(.nowPlayingMoviesListFileURL), default: []] }
    static var favoritesMoviesList: Self {Self[.fileStorage(.favoritesMoviesListFileURL), default: []] }
}

@Reducer
struct MoviesListReducer {
    @Dependency(\.apiClient) var apiClient
    
    @ObservableState
    struct State: Equatable {
        @Shared(.upcomingMoviesList) var upcomingMoviesList
        @Shared(.topRatedMoviesList) var topRatedMoviesList
        @Shared(.nowPlayingMoviesList) var nowPlayingMoviesList
        @Shared(.favoritesMoviesList) var favoritesMoviesList
        
        var selectedCategory: MovieCategory = .upcoming
        var categoryTitel: String = "Filter By Category"
        let categoryFilter = [MovieCategory.upcoming, MovieCategory.topRated, MovieCategory.nowPlaying]
        var shouldNavigateToMovieDetailsView: Bool = false
        var selectedMovieId: MovieDataModel? = nil
        var movieTitleSearchText: String = ""
        var selectedMovieItem: MovieDataModel? = nil
        var page: Int = 1
        @Presents var selectedMovie: MovieDetailsReducer.State?
        
        var moviesToPresent: IdentifiedArrayOf<MovieDataModel> {
            switch self.selectedCategory {
                
            case .upcoming:
                return upcomingMoviesList
            case .topRated:
                return topRatedMoviesList
            case .nowPlaying:
                return nowPlayingMoviesList
            }
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case categorySelected(category: MovieCategory)
        case searchStarted(searchText: String)
        case favoriteTapped(movie: MovieDataModel)
        case movieTapped(movie: MovieDataModel)
        case moviesResponse(IdentifiedArrayOf<MovieDataModel>)
        case movieDetailsResponse(TaskResult<MovieDataNetworkModel>)
        case fetchMoviesListFromPath(path: String)
        case fetchMovieData(movieId: Int)
        case toggleMovieFavorite(movie: MovieDataModel)
        case selectedMovie(PresentationAction<MovieDetailsReducer.Action>)
        case loadNextPage
        case saveMoviesLocally(TaskResult<[MovieDataNetworkModel]>)
        
    }
    
    var body: some ReducerOf<MoviesListReducer> {
        
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .toggleMovieFavorite(let movie):
                var updatedMovie = movie
                updatedMovie.toggleFavorite()
                if updatedMovie.isFavorite {
                    state.$favoritesMoviesList.withLock {$0 += [updatedMovie]}
                } else {
                    state.$favoritesMoviesList.withLock { _ = $0.remove(id: updatedMovie.id) }
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
                return .send(.fetchMoviesListFromPath(path: path))
            case .selectedMovie:
                return .none
                
            case .movieDetailsResponse(.success(let movieDetails)):
                let selectedMovie = MovieDataModel(category: state.selectedCategory, model: movieDetails)
                state.selectedMovieItem = selectedMovie
                return .none
            case .fetchMovieData(let movieId):
                let page = state.page
                return .run { send in
                    do {
                        if let url = URL(string: Endpoints.movieDetails(movieId).path),
                           let movieData = try await apiClient.fetchMovies(url, page) {
                            
                            let movieDetails = try JSONDecoder().decode(MovieDataNetworkModel.self, from: movieData)
                            await send(.movieDetailsResponse(.success(movieDetails)))
                        }
                    } catch let error {
                        await send(.movieDetailsResponse(.failure(error)))
                    }
                }
            case .fetchMoviesListFromPath(let path):
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
                state.selectedCategory = category
                switch category {
                case .upcoming:
                    return .send(.fetchMoviesListFromPath(path: Endpoints.upcoming.path))
                case .topRated:
                    return .send(.fetchMoviesListFromPath(path: Endpoints.topRated.path))
                case .nowPlaying:
                    return .send(.fetchMoviesListFromPath(path: Endpoints.nowPlaying.path))
                }
            case .searchStarted(searchText: let searchText):

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
            case .moviesResponse(_):
//                state.moviesList += IdentifiedArrayOf(uniqueElements: movies)
                return .none
            case .saveMoviesLocally(.success(let movies)):
                var moviesDataArray = IdentifiedArrayOf<MovieDataModel>()
                movies.forEach { fetchedMovie in
                    let movie = MovieDataModel(category: state.selectedCategory, model: fetchedMovie)
                    moviesDataArray.append(movie)
                }
                switch state.selectedCategory {
                case .upcoming:
                    state.$upcomingMoviesList.withLock {$0 += moviesDataArray}
                case .nowPlaying:
                    state.$nowPlayingMoviesList.withLock {$0 += moviesDataArray}
                case .topRated:
                    state.$topRatedMoviesList.withLock {$0 += moviesDataArray}
                }
                return .none

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
    
    
    
    
   
    
    
    
    
//    @MainActor
//    func saveMoviesIfNeeded(modelContext: ModelContext?, movies: [MovieDataNetworkModel], selectedCategory: MovieCategory) -> IdentifiedArrayOf<MovieDataModel> {
//        var persistenMovies = IdentifiedArrayOf<MovieDataModel>()
//        for movie in movies {
//            let persistentMovie = MovieDataModel(isFavorite: false, category: selectedCategory, model: movie)
//            persistenMovies.append(persistentMovie)
//        }
//        var insertionCandidates = persistenMovies
//        let fetchDescriptor = FetchDescriptor<MovieDataModel>()
//        
//        if let storedMovies = try? modelContext?.fetch(fetchDescriptor) {
//            for storedMovie in storedMovies {
//                if let _ = insertionCandidates[id: storedMovie.id] {
//                    insertionCandidates.remove(id: storedMovie.id)
//                }
//            }
//        }
//        print(persistenMovies)
//        for newMovie in insertionCandidates {
//            print("Shauli: New Movie inserted")
//            modelContext?.insert(newMovie)
//        }
//        
//        try? modelContext?.save()
//        return persistenMovies
//        
//    }
    
}

enum MovieCategory: String {
    case upcoming = "Upcoming"
    case topRated = "Top Rated"
    case nowPlaying = "Now Playing"
}
