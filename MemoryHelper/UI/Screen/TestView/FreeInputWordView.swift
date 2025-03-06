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
    
    init(testViewModel: TestViewModel, word: Word) {
        self.testViewModel = testViewModel
        self.word = word
    }
    
    var body: some View {
        VStack {
            Text("Напишите правильный перевод слова")
            Text(word.original)
            DesignTextField(text: $wordInput, editing: $editing, isValid: testViewModel.isValid)
                .focused($isFocused)
            
            Button {
                testViewModel.freeInputWordCheck(word: wordInput)
                isFocused = false
            } label: {
                Text("Проверить")
            }
            
            VStack {
                if testViewModel.isRightWord {
                    NextTestButtonView(testViewModel: testViewModel)
                }
                
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = false
            editing = false
        }
    }
}
    
