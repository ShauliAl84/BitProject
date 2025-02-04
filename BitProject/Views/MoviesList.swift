//
//  MoviesList.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import SwiftUI
import ComposableArchitecture

struct MoviesList: View {
    let store: StoreOf<MoviesListReducer>
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            NavigationStack {
                VStack {
                    Picker(viewStore.categoryTitel, selection: viewStore.binding(get: \.selectedCategory, send: MoviesListReducer.Action.categorySelected)) {
                        ForEach(viewStore.categoryFilter, id:\.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(viewStore.moviesList) { movie in
                                MovieItemView(movieItem: movie) { movieId in
                                    viewStore.send(.favoriteTapped(movieId: movieId))
                                } movieTapeed: { movieId in
                                    viewStore.send(.movieTapped(movieId: movieId))
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: viewStore.binding(get: \.movieTitleSearchText, send: MoviesListReducer.Action.searchStarted))
            
        }
    }
}

#Preview {
    MoviesList(store: .init(initialState: MoviesListReducer.State(), reducer: {
        MoviesListReducer()
    }))
}
