//
//  TestView.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 28.02.2025.
//

import SwiftUI
import SwiftData

struct TestView: View {
    @Bindable var testViewModel: TestViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            switch testViewModel.currentType {
                
            case .freeInput: FreeInputWordView(testViewModel: testViewModel, word: testViewModel.currentWord!)
            case .chooseRightTranslate: ChooseRightTranslateView(testViewModel: testViewModel, word: testViewModel.currentWord!)
            case .listenAndType: EmptyView()
            case .none:
                ProgressView()
            }
        }
        //.toolbarVisibility(.hidden, for: .navigationBar)
    }
}






