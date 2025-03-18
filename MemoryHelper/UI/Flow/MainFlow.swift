//
//  MainFlow.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 21.02.2025.
//

import SwiftUI
import SwiftData

enum Buttons {
    case test, allWords
}

struct MainFlow: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var viewModel: WordViewModel
    @State private var navigationPath = NavigationPath()
    @State private var testViewModel: TestViewModel?
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            MainMenu(navigationPath: $navigationPath, viewModel: viewModel, testViewModel: $testViewModel)
                .onAppear {
                    print("MainFlow appeared")
                }
                .navigationDestination(for: Buttons.self) { destination in
                    switch destination {
                    case .allWords:
                        AllWordsFlow(viewModel: viewModel)
                    case .test:
                        if let _ = testViewModel {
                            TestFlow(viewModel: viewModel, testViewModel: $testViewModel)
                        } else {
                            Text("Error: TestViewModel not initialized")
                        }
                    }
                }
                .onChange(of: testViewModel) { oldValue, newValue in
                    if newValue != nil {
                        print("testViewModel initialized in MainFlow, navigating to test")
                        navigationPath.append(Buttons.test)
                    }
                }
        }
    }
}

