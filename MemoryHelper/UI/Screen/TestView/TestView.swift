//
//  TestView.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 28.02.2025.
//

import SwiftUI

struct TestView: View {
    @Binding var testViewModel: TestViewModel?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            if let testViewModel = testViewModel, let currentWord = testViewModel.currentWord {
                switch testViewModel.currentType {
                case .freeInput:
                    //FreeInputWordView(testViewModel: testViewModel, word: currentWord)
                    ChooseRightTranslateView(testViewModel: testViewModel, word: currentWord)
                case .chooseRightTranslate:
                    ChooseRightTranslateView(testViewModel: testViewModel, word: currentWord)
                case .listenAndType:
                    ChooseRightTranslateView(testViewModel: testViewModel, word: currentWord)
                case .none:
                    ProgressView()
                }
            } else {
                ProgressView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                    testViewModel = nil
                } label: {
                    Image(systemName: "arrow.left")
                    Text("Назад")
                }

            }
        }
        
    }
}
