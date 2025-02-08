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
        var decoder: JSONDecoder {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }
    }
    
    enum Action:Equatable {
        case moviesListActions(MoviesListReducer.Action)
        case favoritesListActions(FavoritesFeature.Action)
        case selectedTab(Tab)
        case toggleMovieFavorite(MovieDataModel)
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
                //                            await send(.displayError("Could not update favorite state for the movie"))
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
            case .favoritesListActions(let action):
                switch action {
                    
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
                    
//                case .binding(_):
//                    <#code#>
//                case .categorySelected(category: let category):
//                    <#code#>
                case .favoriteTapped(movie: let movie):
                    return favoriteTapped(movie, state)
                default:
                    return .none
//                case .movieTapped(movie: let movie):
//                    <#code#>
//                case .movieDetailsResponse(_):
//                    <#code#>
//                case .fetchMoviesListFromPath(path: let path):
//                    <#code#>
//                case .fetchMovieData(movieId: let movieId):
//                    <#code#>
//                
//                    <#code#>
//                case .selectedMovie(_):
//                    <#code#>
//                case .loadNextPage:
//                    <#code#>
//                case .saveMoviesLocally(_):
//                    <#code#>
//                case .displayError(_):
//                    <#code#>
//                case .fetchFromLocal:
//                    <#code#>
                }
                return .none
            case let .selectedTab(tab):
                state.currentTab = tab
                return .none
            }
        }
        .ifLet(\.moviesList.$selectedMovie, action: \.moviesListActions.selectedMovie) {
            MovieDetailsReducer()
        }
    }
    
    
}
