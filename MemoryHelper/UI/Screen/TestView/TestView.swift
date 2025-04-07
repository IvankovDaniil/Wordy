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
    @State private var isShowConfirmedDialog = false
    
    var body: some View {
        VStack(spacing: 0) { 
            if let testViewModel = testViewModel {
                switch testViewModel.currentType {
                case .chooseRightTranslate:
                    ChooseRightTranslateView(testViewModel: testViewModel, word: testViewModel.currentWord!)
                case .none:
                    EndTestView(testViewModel: $testViewModel)
                case .some(.freeInput):
                    FreeInputWordView(testViewModel: testViewModel, word: testViewModel.currentWord!)
                case .some(.listenAndType):
                    ListeningTestView(testViewModel: testViewModel, word: testViewModel.currentWord!)
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    isShowConfirmedDialog = true
                } label: {
                    HStack(spacing: 0) {
                        Image(systemName: "chevron.left")
                        Text("Назад")
                            .font(.custom("Arial", size: 20))
                    }
                    .foregroundStyle(.mainGreen)
                }
            }
            
            ToolbarItem(placement: .principal) {
                if let testViewModel = testViewModel {
                    ProgressBarView(totalValue: Double((testViewModel.testWord.count)), currentValue: Double(testViewModel.currentIndex + 1))
                }
            }
        }
        .confirmationDialog("Вы уверены? Весь прогресс сбросится", isPresented: $isShowConfirmedDialog, titleVisibility: .visible) {
            Button("Да", role: .destructive) {
                dismiss()
                testViewModel = nil
            }
            Button("Нет", role: .cancel) { }
        }
        
    }
}


