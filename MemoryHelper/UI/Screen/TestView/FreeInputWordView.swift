//
//  FreeInputWordView.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 06.03.2025.

import SwiftUI

struct FreeInputWordView: View {
    let testViewModel: TestViewModel
    let word: Word
    
    @State var wordInput: String = ""
    @FocusState private var isFocused: Bool
    @State var editing: Bool = false
    
    
    var body: some View {
        VStack {
            Text("Напишите правильный перевод слова")
                .font(.custom("Arial", size: 19))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text(word.original)
                .font(.custom("Arial", size: 22))
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(12)
                .shadow(radius: 5)
            
            DesignTextField(text: $wordInput, editing: $editing, isValid: testViewModel.isValid)
                .focused($isFocused)
                .padding(.horizontal)
            
            Button {
                testViewModel.freeInputWordCheck(word: wordInput)
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
            
//            VStack {
//                if testViewModel.isRightWord {
//                    NextTestButtonView(testViewModel: testViewModel)
//                        .transition(.opacity)
//                }
//                
//            }
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = false
            editing = false
        }
    }
}
    
