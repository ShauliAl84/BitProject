//
//  MainTabView.swift
//  BitProject
//
//  Created by Shauli Algawi on 05/02/2025.
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
    @State var store = Store(initialState: MoviesListReducer.State()) {
        MoviesListReducer()._printChanges()
        }
   
    
    var body: some View {
        
        TabView {
            Tab("Movies", systemImage: "film") {
                MoviesList(store: store)
            }
            
            Tab("Favorites", systemImage: "star.fill") {
                FavoriteMoviesView(store: store)
            }
        }
    }
}

#Preview {
    
    MainTabView()
}
