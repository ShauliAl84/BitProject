//
//  MovieItemReducer.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MovieItemReducer {
    @ObservableState
    struct State: Equatable {
//        var movieDataItem: MovieDataModel = MovieDataModel.mock
    }
    enum Action: Equatable {
        case imageDownloadCompleted
        case itemTapped(movieItem: MovieDataModel)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .imageDownloadCompleted:
//                state.moviePosterUrl = "movieclapper.fill"
                return .none
            case .itemTapped(_):
                return .none
            }
        }
    }
}

