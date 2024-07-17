//
//  DownloadRecipeAppDemoApp.swift
//  DownloadRecipeAppDemo
//
//  Created by Ausra Balyne on 17/07/2024.
//

import SwiftUI
import SwiftData

@main
struct DownloadRecipeAppDemoApp: App {
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
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
