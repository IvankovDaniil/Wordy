//
//  FreeInputWordView.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 06.03.2025.

import SwiftUI

struct FreeInputWordView: View {
    @Bindable var testViewModel: TestViewModel
    let word: Word
    
    @State var wordInput: String = ""
    @FocusState private var isFocused: Bool
    @State var editing: Bool = false
    
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 20) {
                Text("Напишите правильный перевод слова")
                    .ruleTextModifier()
                
                Text(word.original)
                    .wordTextModifier()
                
                AcceptButtonView(testViewModel: testViewModel, word: word)
                    .focused($isFocused)
            }
            .frame(height: 500)
            .frame(maxHeight: .infinity)
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = false
            editing = false
        }
    }
}
    
