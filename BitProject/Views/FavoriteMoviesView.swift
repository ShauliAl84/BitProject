//
//  FavoriteMoviesView.swift
//  BitProject
//
//  Created by Shauli Algawi on 05/02/2025.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

struct FavoriteMoviesView: View {
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    @Query(filter: #Predicate<PersistantMovieData> {$0.isFavorite == true}) private var favMovies: [PersistantMovieData]
    @Environment(\.modelContext) var modelContext
    let store: StoreOf<MoviesListReducer>
    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: {$0}) { viewStore in
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(viewStore.favoritesMoviesList) { movie in
                            MovieItemView(movieItem: movie) {
                                viewStore.send(.favoriteTapped(movie: movie))
                            } movieTapeed: {
                                viewStore.send(.movieTapped(movie: movie))
                            }
                        }
                    }
                    .onAppear {
                        viewStore.send(.fetchFavoritesMovies(modelContext))
                    }
                    .navigationDestination(store: self.store.scope(state: \.$selectedMovie, action: {.selectedMovie($0)})) { store in
                        MovieDetails(store: store)
                    }
                }
            }
        }
    }
}

#Preview {
    FavoriteMoviesView( store: .init(initialState: MoviesListReducer.State(), reducer: {
        MoviesListReducer()
    }))
}
