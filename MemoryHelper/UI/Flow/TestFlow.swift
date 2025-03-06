//
//  TestFlow.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 03.03.2025.
//

import SwiftUI

struct TestFlow: View {
    @Bindable var viewModel: WordViewModel
    

    var body: some View {
        TestView(testViewModel: TestViewModel(wordsViewModel: viewModel))
    }
}


