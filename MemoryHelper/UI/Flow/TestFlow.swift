//
//  TestFlow.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 03.03.2025.
//

import SwiftUI

struct TestFlow: View {
    @Bindable var viewModel: WordViewModel
    @Binding var testViewModel: TestViewModel?
     
    init(viewModel: WordViewModel, testViewModel: Binding<TestViewModel?>) {
        print("TestFlow init")
        self.viewModel = viewModel
        self._testViewModel = testViewModel
    }
    

    var body: some View {
        VStack {
            TestView(testViewModel: $testViewModel)
                .background {
                    Image(.bg)
                        .opacity(0.05)
                }

        }
    }
}


