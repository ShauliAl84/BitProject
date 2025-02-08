//
//  MainTabView.swift
//  BitProject
//
//  Created by Shauli Algawi on 05/02/2025.
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {

    @Bindable var store: StoreOf<MainFeature>
   
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.5).ignoresSafeArea()
                TabView {
                    Tab("Movies", systemImage: "film") {
                        MoviesList(store: store.scope(state: \.moviesList, action: \.moviesListActions))
                    }
                    
                    Tab("Favorites", systemImage: "star.fill") {
                        FavoriteMoviesView(store: store.scope(state: \.favoritesMoviesList, action: \.favoritesListActions))
                    }
                }
                
                .navigationDestination(store: self.store.scope(state: \.$selectedMovie , action: \.selectedMovie)) { store in
                    MovieDetails(store: store)
                }
                .alert("Error", isPresented: $store.shouldDisplayErrorAlert) {
                    
                } message: {
                    Text(store.errorString)
                }
            }
        }

    }
}

//#Preview {
//    
//    MainTabView(store: .init(initialState: MainFeature.State(moviesList: MoviesListReducer.State(),
//                                                             favoritesMoviesList: FavoritesFeature.State()), reducer: {
//        MainFeature()
//    }))
//}
