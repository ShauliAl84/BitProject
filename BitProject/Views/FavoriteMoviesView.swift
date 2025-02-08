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
    var store: StoreOf<FavoritesFeature>
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(store.favoritesMoviesList) { movie in
                        MovieItemView(movieItem: movie) {
                            store.send(.favoriteTapped(movie))
                        } movieTapeed: {
                            store.send(.movieTapped(movie))
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    FavoriteMoviesView( store: .init(initialState: MoviesListReducer.State(), reducer: {
//        MoviesListReducer()
//    }))
//}
