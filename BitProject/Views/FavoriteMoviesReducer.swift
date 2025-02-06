//
//  FavoriteMoviesReducer.swift
//  BitProject
//
//  Created by Shauli Algawi on 05/02/2025.
//

import Foundation
import ComposableArchitecture
import SwiftData

struct FavoriteMoviesReducer: Reducer {
    struct State: Equatable {
        var favMovies = IdentifiedArrayOf<PersistantMovieData>()
        @PresentationState var selectedMovie: MovieDetailsReducer.State?
    }
    
    enum Action: Equatable {
        case toggleFavorite(PersistantMovieData, ModelContext)
        case showMovieDetails(PersistantMovieData)
        case selectedMovie(PresentationAction<MovieDetailsReducer.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .toggleFavorite(let movie, let modelContext):
                movie.isFavorite = !movie.isFavorite
                if movie.isFavorite {
                    state.favMovies.append(movie)
                } else {
                    state.favMovies.remove(movie)
                }
                try? modelContext.save()
                return .none
            case .showMovieDetails(let movie):
                state.selectedMovie = MovieDetailsReducer.State(movie: movie)
                return .none
            case .selectedMovie(_):
                return .none
            }
        }
        .ifLet(\.$selectedMovie, action: /Action.selectedMovie) {
            MovieDetailsReducer()
        }
    }
}
