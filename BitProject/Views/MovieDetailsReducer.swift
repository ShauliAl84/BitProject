//
//  MovieDetailsReducer.swift
//  BitProject
//
//  Created by Shauli Algawi on 04/02/2025.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct MovieDetailsReducer {
    @Dependency(\.apiClient) var apiClient
    
    @ObservableState
    struct State:  Equatable {
        var movie: MovieDataModel? = nil
        var shouldShowTrailer: Bool = false
        var loadingTrailer: Bool = false
        var trailerId: String = ""
        var errorString: String = ""
        var shouldDisplayError: Bool = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case showTrailer
        case fetchTrailerInfo(Int)
        case movieVideosFetched(TaskResult<[MovieVideoNetworkModel]>)
        case showError(String)
    }
    
    
    
    var body: some ReducerOf<MovieDetailsReducer> {
        BindingReducer()
            
        Reduce { state, action in
            switch action {

            case .binding:
                return .none
            default:
                return .none
            }
        }
    }
}
