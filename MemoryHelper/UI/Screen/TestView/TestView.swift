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
            Spacer()
            if let testViewModel = testViewModel, let currentWord = testViewModel.currentWord {
                switch testViewModel.currentType {
                case .freeInput:
                    FreeInputWordView(testViewModel: testViewModel, word: currentWord)
                case .chooseRightTranslate:
                    ChooseRightTranslateView(testViewModel: testViewModel, word: currentWord)
                case .listenAndType:
                    ListeningTestView(testViewModel: testViewModel, word: currentWord)
                case .none:
                    EndTestView(testViewModel: $testViewModel)
                }
                
            } else {
                ProgressView()
            }
            Spacer()
        }
        .background {
            Image(.bg)
                .opacity(0.1)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    isShowConfirmedDialog = true
                } label: {
                    HStack(spacing: 0) {
                        Image(systemName: "chevron.left")
                        Text("Назад")
                    }
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


struct AcceptButtonView: View {
    @Bindable var testViewModel: TestViewModel
    let word: Word
    
    @State var wordInput: String = ""
    @FocusState private var isFocused: Bool
    @State var editing: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            DesignTextField(text: $wordInput, editing: $editing, isValid: testViewModel.isValid)
                .focused($isFocused)
                .padding(.horizontal)
                .autocorrectionDisabled(true)
                .keyboardType(.asciiCapable)
            
            Button {
                print("До метода: ", word.translation)
                testViewModel.freeInputWordCheck(word: wordInput)
                print("после: ", word.translation)
                isFocused = false
            } label: {
                Text("Проверить")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            NextTestButtonView(isRightWord: $testViewModel.isRightWord, action: {
                testViewModel.nextTest()
                wordInput = ""
            })
            .transition(.opacity)
            .opacity(testViewModel.isRightWord ? 1 : 0)
        }
    }
}
