//
//  MovieDetailsReducer.swift
//  BitProject
//
//  Created by Shauli Algawi on 04/02/2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MovieDetailsReducer {
    
    @ObservableState
    struct State:  Equatable {
        let movie: MovieDataModel
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case backButtonTapped
    }
    
    var body: some ReducerOf<MovieDetailsReducer> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            case .binding:
                return .none
            }
        }
    }
}
