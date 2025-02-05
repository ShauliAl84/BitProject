//
//  MoviesListReducer.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import Foundation
import ComposableArchitecture

struct MoviesListReducer: Reducer {
    @Dependency(\.apiClient) var apiClient
    var body: some ReducerOf<MoviesListReducer> {
        Reduce { state, action in
            switch action {
            case .addToFvoriteMoviesList(let movie):
                state.favoritesMoviesList.append(movie)
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
            case .fetchMoviesListFromPath(let path):
                let page = state.page
                return .run { send in
                    do {
                        if let url = URL(string: path),
                           let fetchedMoviesData = try await apiClient.fetchMovies(url, page) {
                            
                            let moviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: fetchedMoviesData)
                            await send(.moviesResponse(.success(moviesResponse.results)))
                            
                        } else {
                            await send(.moviesResponse(.success([])))
                        }
                        
                    } catch let error {
                        await send(.moviesResponse(.failure(error)))
                    }
                }
            case .categorySelected(let category):
                if state.selectedCategory != category {
                    state.moviesList = IdentifiedArrayOf<MovieDataModel>()
                    state.page = 1
                }
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
                          "favorite": true
                        ]
                        if let url = URL(string: path),
                           let data = try await apiClient.addRemoveFavorite(url, parameters) {
                            
                            let favoriteResponse = try JSONDecoder().decode(FavoriteResponseModel.self, from: data)
                            if favoriteResponse.success == true {
                                await send(.addToFvoriteMoviesList(movie: movie))
                            }
                        }
                        
                    } catch let error {
                        await send(.moviesResponse(.failure(error)))
                    }
                }
            case .movieTapped(let movie):
                state.selectedMovie = MovieDetailsReducer.State(movie: movie)
                return .none
                //display the details view
            case .moviesResponse(.success(let movies)):
                state.moviesList += IdentifiedArrayOf(uniqueElements: movies)
                return .none
            case .moviesResponse(.failure(let error)):
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
        var moviesList = IdentifiedArrayOf<MovieDataModel>()
        var favoritesMoviesList = IdentifiedArrayOf<MovieDataModel>()
        var selectedCategory: MovieCategory = .upcoming
        var categoryTitel: String = "Filter By Category"
        let categoryFilter = [MovieCategory.upcoming, MovieCategory.topRated, MovieCategory.nowPlaying]
        var shouldNavigateToMovieDetailsView: Bool = false
        var selectedMovieId: MovieDataModel? = nil
        var movieTitleSearchText: String = ""
        var selectedMovieItem: MovieDataModel? = nil
        var page: Int = 1
        @PresentationState var selectedMovie: MovieDetailsReducer.State?
    }
    
    enum Action: Equatable {
        case categorySelected(category: MovieCategory)
        case searchStarted(searchText: String)
        case favoriteTapped(movie: MovieDataModel)
        case movieTapped(movie: MovieDataModel)
        case moviesResponse(TaskResult<[MovieDataModel]>)
        case movieDetailsResponse(TaskResult<MovieDataModel>)
        case fetchMoviesListFromPath(path: String)
        case fetchMovieData(movieId: Int)
        case addToFvoriteMoviesList(movie: MovieDataModel)
        case selectedMovie(PresentationAction<MovieDetailsReducer.Action>)
        case loadNextPage
    }
    
}

enum MovieCategory: String {
    case upcoming = "Upcoming"
    case topRated = "Top Rated"
    case nowPlaying = "Now Playing"
}
