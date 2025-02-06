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
    private let container: ModelContainer
    private let imageCacheManager: ImageCacheManager
    
    init() {
        let schema = Schema([PersistantMovieData.self, CachedImage.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        self.container = try! ModelContainer(for: schema, configurations: [config])
        self.imageCacheManager = ImageCacheManager(container: container)
    }


    var body: some Scene {
        WindowGroup {
            MainTabView()
            .environment(imageCacheManager)
            
        }
        .modelContainer(container)
    }
}
