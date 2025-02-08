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
     var store: StoreOf<MoviesListReducer>
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(store.favoritesMoviesList) { movie in
                        MovieItemView(movieItem: movie) {
                            store.send(.favoriteTapped(movie: movie))
                        } movieTapeed: {
                            store.send(.movieTapped(movie: movie))
                        }
                    }
                }
                .navigationDestination(store: self.store.scope(state: \.$selectedMovie, action: {.selectedMovie($0)})) { store in
                    MovieDetails(store: store)
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
