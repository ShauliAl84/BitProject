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
        
        NavigationStack {
            WithViewStore(store, observe: {$0}) { viewStore in
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
                                } movieTapeed: { movie in
                                    viewStore.send(.movieTapped(movie: movie))
                                }
                            }
                        }
                        .onAppear {
                            viewStore.send(.fetchMoviesListFromPath(path: Endpoints.upcoming.path))
                        }
                        .navigationDestination(store: self.store.scope(state: \.$selectedMovie, action: {.selectedMovie($0)})) { store in
                            MovieDetails(store: store)
                        }
                        
                    }
                }
            }
        }
    }
}

#Preview {
    MoviesList(store: .init(initialState: MoviesListReducer.State(), reducer: {
        MoviesListReducer()
    }))
}
