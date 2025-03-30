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
    
    @State private var viewModel: WordViewModel
    @State private var isShowLaunchScreen: Bool = true
    
    init() {
        let context = sharedModelContainer.mainContext
        _viewModel = State(wrappedValue: WordViewModel(modelContext: context))
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                MainFlow(viewModel: viewModel)
                    .opacity(isShowLaunchScreen ? 0 : 1)
                
                if isShowLaunchScreen {
                    LaunchScreenAnimation()
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    isShowLaunchScreen = false
                                }
                            }
                        }
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
