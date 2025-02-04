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
                
            case .selectedMovie:
                return .none
                
            case .movieDetailsResponse(.success(let movieDetails)):
                state.shouldNavigateToMovieDetailsView = true
                state.selectedMovieItem = movieDetails
                return .none
            case .fetchMovieData(let movieId):
                return .run { send in
                    do {
                        if let url = URL(string: Endpoints.movieDetails(movieId).path) {
                            let movieData = try await apiClient.fetchMovies(url)
                            let movieDetails = try JSONDecoder().decode(MovieDataModel.self, from: movieData)
                            await send(.movieDetailsResponse(.success(movieDetails)))
                        }
                    } catch let error {
                        await send(.movieDetailsResponse(.failure(error)))
                    }
                }
            case .fetchMoviesListFromPath(let path):
                return .run { send in
                    do {
                        if let url = URL(string: path) {
                            let fetchedMoviesData = try await apiClient.fetchMovies(url)
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
            case .favoriteTapped(let movieId):
                // Request to add/remove from favorites
                return .none
            case .movieTapped(let movie):
                state.selectedMovie = MovieDetailsReducer.State(movie: movie)
                return .none
                //display the details view
            case .moviesResponse(.success(let movies)):
                state.moviesList = IdentifiedArrayOf(uniqueElements: movies)
                return .none
            case .moviesResponse(.failure(let error)):
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
        var selectedCategory: MovieCategory = .upcoming
        var categoryTitel: String = "Filter By Category"
        let categoryFilter = [MovieCategory.upcoming, MovieCategory.topRated, MovieCategory.nowPlaying]
        var shouldNavigateToMovieDetailsView: Bool = false
        var selectedMovieId: MovieDataModel? = nil
        var movieTitleSearchText: String = ""
        var selectedMovieItem: MovieDataModel? = nil
        
        @PresentationState var selectedMovie: MovieDetailsReducer.State?
    }
    
    enum Action: Equatable {
        case categorySelected(category: MovieCategory)
        case searchStarted(searchText: String)
        case favoriteTapped(movieId: Int)
        case movieTapped(movie: MovieDataModel)
        case moviesResponse(TaskResult<[MovieDataModel]>)
        case movieDetailsResponse(TaskResult<MovieDataModel>)
        case fetchMoviesListFromPath(path: String)
        case fetchMovieData(movieId: Int)
        
        case selectedMovie(PresentationAction<MovieDetailsReducer.Action>)
    }
    
}

enum MovieCategory: String {
    case upcoming = "Upcoming"
    case topRated = "Top Rated"
    case nowPlaying = "Now Playing"
}
