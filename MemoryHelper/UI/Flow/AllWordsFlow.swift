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
        AllWordsView(viewModel: viewModel)
            .background {
                Image(.bg)
                    .resizable(resizingMode: .tile)
                    .opacity(0.05)
                    .ignoresSafeArea()
            }
        
    }
}

