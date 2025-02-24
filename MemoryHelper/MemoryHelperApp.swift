//
//  MemoryHelperApp.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 21.02.2025.
//

import SwiftUI
import SwiftData

@main
struct MemoryHelperApp: App {
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([Word.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: config)
    }()
    
    var body: some Scene {
        WindowGroup {
            MainFlow(context: sharedModelContainer.mainContext)
        }
        .modelContainer(sharedModelContainer)
    }
}
