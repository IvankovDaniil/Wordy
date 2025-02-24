//
//  AllWordsFlow.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 24.02.2025.
//

import SwiftUI

struct AllWordsFlow: View {
    @Binding var viewModel: WordViewModel
    
    var body: some View {
        ScrollView {
            AllWordsView(viewModel: $viewModel)
        }
        .background {
            Image(.bg)
                .resizable(resizingMode: .tile)
                .opacity(0.2)
                .ignoresSafeArea()
        }
        
    }
}
