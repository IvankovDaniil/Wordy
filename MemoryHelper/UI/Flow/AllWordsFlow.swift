//
//  AllWordsFlow.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 24.02.2025.
//

import SwiftUI


struct AllWordsFlow: View {
    @Bindable var viewModel: WordViewModel
    
    var body: some View {
        NavigationStack {
            AllWordsView(viewModel: viewModel)
        }
    }
}

