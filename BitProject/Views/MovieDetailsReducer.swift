//
//  MovieDetailsReducer.swift
//  BitProject
//
//  Created by Shauli Algawi on 04/02/2025.
//

import Foundation
import ComposableArchitecture

struct MovieDetailsReducer: Reducer {
    struct State: Equatable {
        let movie: PersistantMovieData
    }
    
    enum Action: Equatable {
        case backButtonTapped
    }
    
    var body: some ReducerOf<MovieDetailsReducer> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            }
        }
    }
}
