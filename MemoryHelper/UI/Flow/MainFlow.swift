//
//  MainFlow.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 21.02.2025.
//

import SwiftUI
import SwiftData

struct MainFlow: View {
    @Environment(\.modelContext) var modelContext
    @State var viewModel: WordViewModel
    
    init(context: ModelContext) {
        _viewModel = State(wrappedValue: WordViewModel(modelContext: context))
    }
    
    var body: some View {
        NavigationStack {
            MainMenu(viewModel: $viewModel)
        }
    }
}

