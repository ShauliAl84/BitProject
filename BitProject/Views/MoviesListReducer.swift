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
        let categoryTitel: String = "Filter By Category"
        let categoryFilter = [MovieCategory.upcoming, MovieCategory.topRated, MovieCategory.nowPlaying]
        var selectedMovieItem: MovieDataModel? = nil
        var page: Int = 1
        @Presents var selectedMovie: MovieDetailsReducer.State?
        var errorString: String = ""
        var shouldDisplayErrorAlert: Bool = false
        var searchText: String = ""
        
        var decoder: JSONDecoder {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }
        
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
        case favoriteTapped(movie: MovieDataModel)
        case movieTapped(movie: MovieDataModel)
        case movieDetailsResponse(TaskResult<MovieDataNetworkModel>)
        case fetchMoviesListFromPath(path: String)
        case fetchMovieData(movieId: Int)
        case toggleMovieFavorite(movie: MovieDataModel)
        case selectedMovie(PresentationAction<MovieDetailsReducer.Action>)
        case loadNextPage
        case saveMoviesLocally(TaskResult<[MovieDataNetworkModel]>)
        case displayError(String)
        case fetchFromLocal
        
    }
    
    
    
    var body: some ReducerOf<MoviesListReducer> {
        
        BindingReducer()
            .onChange(of: \.selectedCategory) { oldValue, newValue in
                Reduce { state, action in
                        .send(.categorySelected(category: newValue))
                }
            }
            
        
        Reduce { state, action in
            switch action {
            case .fetchFromLocal:
                switch state.selectedCategory {
                case .upcoming:
                    guard let data = try? Data(contentsOf: .upcomingMoviesListFileURL) else {
                        state.$upcomingMoviesList.withLock { $0 += IdentifiedArrayOf<MovieDataModel>() }
                        return .none
                    }
                    do {
                        let chachedList = try state.decoder.decode([MovieDataModel].self, from: data)
                        state.$upcomingMoviesList.withLock { $0 += IdentifiedArrayOf<MovieDataModel>(uniqueElements: chachedList) }
                        
                    }catch let error {
                        print(error.localizedDescription)
                    }
                    return .none
                case .topRated:
                    guard let data = try? Data(contentsOf: .topRatedMoviesListFileURL) else {
                        state.$topRatedMoviesList.withLock { $0 += IdentifiedArrayOf<MovieDataModel>() }
                        return .none
                    }
                    do {
                        let chachedList = try state.decoder.decode([MovieDataModel].self, from: data)
                        state.$topRatedMoviesList.withLock { $0 += IdentifiedArrayOf<MovieDataModel>(uniqueElements: chachedList) }
                        
                    }catch let error {
                        print(error.localizedDescription)
                    }
                    return .none
                case .nowPlaying:
                    guard let data = try? Data(contentsOf: .nowPlayingMoviesListFileURL) else {
                        state.$nowPlayingMoviesList.withLock { $0 += IdentifiedArrayOf<MovieDataModel>() }
                        return .none
                    }
                    do {
                        let chachedList = try state.decoder.decode([MovieDataModel].self, from: data)
                        state.$nowPlayingMoviesList.withLock { $0 += IdentifiedArrayOf<MovieDataModel>(uniqueElements: chachedList) }
                        
                    }catch let error {
                        print(error.localizedDescription)
                    }
                    return .none
                }
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
                let decoder = state.decoder
                return .run { send in
                    do {
                        if let url = URL(string: Endpoints.movieDetails(movieId).path),
                           let movieData = try await apiClient.fetchMovies(url, page) {
                            
                            let movieDetails = try decoder.decode(MovieDataNetworkModel.self, from: movieData)
                            await send(.movieDetailsResponse(.success(movieDetails)))
                        }
                    } catch let error {
                        await send(.movieDetailsResponse(.failure(error)))
                    }
                }
            case .fetchMoviesListFromPath(let path):
                let page = state.page
                let decoder = state.decoder
                return .run { send in
                    do {
                        if let url = URL(string: path),
                           let fetchedMoviesData = try await apiClient.fetchMovies(url, page) {
                            print("movies downloaded")
                            
                            let moviesResponse = try decoder.decode(MoviesResponse.self, from: fetchedMoviesData)
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
            
            case .favoriteTapped(let movie):
                let path = Endpoints.favorite(movie.id).path
                let decoder = state.decoder
                return .run { send in
                    do {
                        let parameters = [
                            "media_type": "movie",
                            "media_id": movie.id,
                            "favorite": !movie.isFavorite
                        ]
                        if let url = URL(string: path),
                           let data = try await apiClient.addRemoveFavorite(url, parameters) {
                            
                            let favoriteResponse = try decoder.decode(FavoriteResponseModel.self, from: data)
                            if favoriteResponse.success == true {
                                await send(.toggleMovieFavorite(movie: movie))
                            }
                        }
                        
                    } catch let error {
                        await send(.displayError("Could not update favorite state for the movie"))
                        print(error.localizedDescription)
                    }
                }
            case .movieTapped(let movie):
                state.selectedMovie = MovieDetailsReducer.State(movie: movie)
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
                return .send(.displayError(error.localizedDescription))
            case .movieDetailsResponse(.failure(let error)):
                return .send(.displayError(error.localizedDescription))
            case .displayError(let errorMessage):
                state.errorString = errorMessage
                state.shouldDisplayErrorAlert = true
                return .none
            }
        
        }
        .ifLet(\.$selectedMovie, action: /Action.selectedMovie) {
            MovieDetailsReducer()
        }
    }
}

enum MovieCategory: String {
    case upcoming = "Upcoming"
    case topRated = "Top Rated"
    case nowPlaying = "Now Playing"
}
