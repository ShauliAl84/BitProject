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
        let movie: MovieDataModel
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
            case .showError(let errorMessage):
                state.errorString = errorMessage
                state.shouldDisplayError = true
                return .none
            case .movieVideosFetched(.failure(let error)):
                return .send(.showError(error.localizedDescription))
            case .movieVideosFetched(.success(let videos)):
                if let video = videos.first {
                    state.loadingTrailer = false
                    state.trailerId = video.videoId
                    state.shouldShowTrailer.toggle()
                }
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
            case .showTrailer:
                state.loadingTrailer = true
                return .send(.fetchTrailerInfo(state.movie.id))
            case .binding:
                return .none
            }
        }
    }
}
