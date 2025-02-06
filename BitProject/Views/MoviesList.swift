//
//  MoviesList.swift
//  LatestMovieApp
//
//  Created by Shauli Algawi on 03/02/2025.
//

import SwiftUI
import ComposableArchitecture
import SwiftData

struct MoviesList: View {
    @Bindable var store: StoreOf<MoviesListReducer>
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    

    var body: some View {
        NavigationStack {
            VStack {
                Picker(store.categoryTitel, selection: $store.selectedCategory) {
                    ForEach(store.categoryFilter, id:\.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                ScrollView {
                    LazyVGrid(columns: columns) {
                       
                        ForEach(store.moviesToPresent) { movie in
                            MovieItemView(movieItem: movie) {
                                store.send(.favoriteTapped(movie: movie))
                            } movieTapeed: {
                                store.send(.movieTapped(movie: movie))
                            }
                        }
                    }
                    .onAppear {
//                        store.send(.fetchMoviesFromLocalStorage(modelContext, MovieCategory.upcoming))
                        store.send(.fetchMoviesListFromPath(path: Endpoints.upcoming.path))
                    }
                    .navigationDestination(store: self.store.scope(state: \.$selectedMovie, action: {.selectedMovie($0)})) { store in
                        MovieDetails(store: store)
                    }
                }
                .onScrollPhaseChange { oldPhase, newPhase in
                    store.send(.loadNextPage)
                }
            }
//            .searchable(text: $store.movieTitleSearchText)
        }
    }
}

#Preview {
    MoviesList(store: .init(initialState: MoviesListReducer.State(), reducer: {
        MoviesListReducer()
    }))
}
