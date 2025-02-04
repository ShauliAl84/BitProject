//
//  MoviesListReducer.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import Foundation
import ComposableArchitecture

struct MoviesListReducer: Reducer {
    
    var body: some ReducerOf<MoviesListReducer> {
        Reduce { state, action in
            switch action {
                
            case .categorySelected(let category):
                state.selectedCategory = category
                switch category {
                case .upcoming:
                    state.moviesList = IdentifiedArrayOf(uniqueElements: MovieDataModel.upComingMockList)
                case .topRated:
                    state.moviesList = IdentifiedArrayOf(uniqueElements: MovieDataModel.topRatedMockList)
                case .nowPlaying:
                    state.moviesList = IdentifiedArrayOf(uniqueElements: MovieDataModel.mockList)
                }
                return .none
            case .searchStarted(searchText: let searchText):
                let filterdList = state.moviesList.filter {$0.originalTitle.contains(searchText)}
                state.moviesList = filterdList
                return .none
            case .favoriteTapped(let movieId):
                // Request to add/remove from favorites
                return .none
            case .movieTapped(movieId: let movieId):
                state.selectedMovieId = movieId
                state.shouldNavigateToMovieDetailsView = true
                return .none
                //display the details view
            }
        }
    }
    
    struct State: Equatable {
        var moviesList = IdentifiedArrayOf(uniqueElements: MovieDataModel.upComingMockList)
        var selectedCategory: MovieCategory = .upcoming
        var categoryTitel: String = "Filter By Category"
        let categoryFilter = [MovieCategory.upcoming, MovieCategory.topRated, MovieCategory.nowPlaying]
        var shouldNavigateToMovieDetailsView: Bool = false
        var selectedMovieId: Int? = nil
        var movieTitleSearchText: String = ""
    }
    
    enum Action: Equatable {
        case categorySelected(category: MovieCategory)
        case searchStarted(searchText: String)
        case favoriteTapped(movieId: Int)
        case movieTapped(movieId: Int)
    }
    
}

enum MovieCategory: String {
    case upcoming = "Upcoming"
    case topRated = "Top Rated"
    case nowPlaying = "Now Playing"
}
