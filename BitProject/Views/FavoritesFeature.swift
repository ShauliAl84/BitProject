//
//  FavoritesFeature.swift
//  BitProject
//
//  Created by Shauli Algawi on 08/02/2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct FavoritesFeature {
    @ObservableState
    struct State: Equatable {
        @Shared(.favoritesMoviesList) var favoritesMoviesList
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case favoriteTapped(MovieDataModel)
        case movieTapped(MovieDataModel)
    }
    
    var body: some ReducerOf<FavoritesFeature> {
        Reduce {state, action in
            return .none
        }
    }
}
