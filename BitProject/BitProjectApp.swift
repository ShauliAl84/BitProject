//
//  BitProjectApp.swift
//  BitProject
//
//  Created by Shauli Algawi on 03/02/2025.
//

import SwiftUI
import SwiftData
import ImageCacheKit

@main
struct BitProjectApp: App {
   
    var body: some Scene {
        WindowGroup {
            MainTabView(store: .init(initialState: MainFeature.State(moviesList: MoviesListReducer.State(),
                                                                     favoritesMoviesList: FavoritesFeature.State()), reducer: {
                MainFeature()
            }))
        }
    }
}
