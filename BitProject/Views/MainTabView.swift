//
//  MainTabView.swift
//  BitProject
//
//  Created by Shauli Algawi on 05/02/2025.
//

import SwiftUI
import ImageCacheKit
import SwiftData
import ComposableArchitecture

struct MainTabView: View {
    @Environment(\.modelContext) var modelContext
    @State var store = Store(initialState: MoviesListReducer.State()) {
        MoviesListReducer()
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
    
    let schema = Schema([PersistantMovieData.self, CachedImage.self])
    let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    let container = try! ModelContainer(for: schema, configurations: [config])
    let imageCacheManager = ImageCacheManager(container: container)
    
    MainTabView()
        .environment(imageCacheManager)
}
