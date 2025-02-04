//
//  BitProjectApp.swift
//  BitProject
//
//  Created by Shauli Algawi on 03/02/2025.
//

import SwiftUI
import SwiftData

@main
struct BitProjectApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MoviesList(store: .init(initialState: MoviesListReducer.State(), reducer: {
                MoviesListReducer()._printChanges()
            }))
            
        }
        .modelContainer(sharedModelContainer)
    }
}
