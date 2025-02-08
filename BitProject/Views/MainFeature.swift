//
//  MainFeature.swift
//  BitProject
//
//  Created by Shauli Algawi on 08/02/2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MainFeature {
    @Dependency(\.apiClient) var apiClient
    enum Tab {
        case moviesList
        case favorites
    }
    
    @ObservableState
    struct State: Equatable {
        var currentTab: Tab = .moviesList
        var moviesList: MoviesListReducer.State
        var favoritesMoviesList: FavoritesFeature.State
        var errorString: String = ""
        var shouldDisplayErrorAlert: Bool = false
        @Presents var selectedMovie: MovieDetailsReducer.State?
        var decoder: JSONDecoder {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }
    }
    
    enum Action:BindableAction, Equatable {
        case binding(BindingAction<State>)
        case moviesListActions(MoviesListReducer.Action)
        case favoritesListActions(FavoritesFeature.Action)
        case selectedTab(Tab)
        case toggleMovieFavorite(MovieDataModel)
        case displayError(String)
        case selectedMovie(PresentationAction<MovieDetailsReducer.Action>)
        case fetchTrailerInfo(Int)
        case movieVideosFetched(TaskResult<[MovieVideoNetworkModel]>)
    }
    
    fileprivate func favoriteTapped(_ movie: MovieDataModel, _ state: MainFeature.State) -> Effect<MainFeature.Action> {
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
                        await send(.toggleMovieFavorite(movie))
                    }
                }
                
            } catch let error {
                await send(.displayError("Could not update favorite state for the movie"))
                print(error.localizedDescription)
            }
        }
    }
    
    
    var body: some ReducerOf<MainFeature> {
        
        Scope(state: \.moviesList, action: \.moviesListActions) {
            MoviesListReducer()
        }
        
        Scope(state: \.favoritesMoviesList, action: \.favoritesListActions) {
            FavoritesFeature()
        }
        
        
        
        Reduce {state, action in
            switch action {
            case .selectedMovie(let action):
                switch action {
                
                case .dismiss:
                    state.selectedMovie?.shouldShowTrailer = false
                    state.selectedMovie = nil
                    return .none
                case .presented(let action):
                    switch action {
                    case .showTrailer:
                        guard let movieId = state.selectedMovie?.movie?.id else {return .none}
                        state.selectedMovie?.loadingTrailer = true
                        return .send(.fetchTrailerInfo(movieId))
                    case .binding:
                        state.selectedMovie?.shouldShowTrailer = false
                        state.selectedMovie = nil
                        return .none
                    default:
                        return .none
                    }
                }
                
            case .binding:
                return .none
            case .displayError(let errorMessage):
                state.shouldDisplayErrorAlert = true
                state.errorString = errorMessage
                return .none
                
            
            case .favoritesListActions(let action):
                switch action {
                case .movieTapped(let movie):
                    state.selectedMovie = MovieDetailsReducer.State(movie: movie)
                    return .none
                case .favoriteTapped(let movie):
                    return favoriteTapped(movie, state)
                case .binding(_):
                    return .none
                }
            case .toggleMovieFavorite(let movie):
                var updatedMovie = movie
                updatedMovie.toggleFavorite()
                if updatedMovie.isFavorite {
                    state.favoritesMoviesList.$favoritesMoviesList.withLock {$0 += [updatedMovie]}
                } else {
                    state.favoritesMoviesList.$favoritesMoviesList.withLock { _ = $0.remove(id: updatedMovie.id) }
                }
                
                return .none
            case .moviesListActions(let action):
                switch action {
                case .movieTapped(movie: let movie):
                    state.selectedMovie = MovieDetailsReducer.State(movie: movie)
                    return .none
                case .favoriteTapped(movie: let movie):
                    return favoriteTapped(movie, state)
                default:
                    return .none

                }
            case let .selectedTab(tab):
                state.currentTab = tab
                return .none
            case .fetchTrailerInfo(let movieId):
                return .run { send in
                    do {
                        if let url = URL(string: Endpoints.videos(movieId).path),
                           let fetchMovieVideosData = try await apiClient.fetchMovieVideos(url) {
                            
                            let moviesVideosResponse = try JSONDecoder().decode(MovieVideosReponseNetworkModel.self, from: fetchMovieVideosData)
                            return await send(.movieVideosFetched(.success(moviesVideosResponse.results)))
                        }
                    } catch let error {
                        return await send(.movieVideosFetched(.failure(error)))
                    }
                    
                }
            case .movieVideosFetched(.success(let videos)):
                if let video = videos.first {
                    state.selectedMovie?.loadingTrailer = false
                    state.selectedMovie?.trailerId = video.key
                    state.selectedMovie?.shouldShowTrailer.toggle()
                }
                return .none
            case .movieVideosFetched(.failure(let error)):
                return .none
            }
        }
        .ifLet(\.$selectedMovie, action: \.selectedMovie) {
            MovieDetailsReducer()
        }
    }
    
    
}
