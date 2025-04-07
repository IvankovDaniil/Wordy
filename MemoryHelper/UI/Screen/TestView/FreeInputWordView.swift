//
//  FreeInputWordView.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 06.03.2025.

import SwiftUI

struct FreeInputWordView: View {
    @Bindable var testViewModel: TestViewModel
    let word: Word
    //@Binding var path: NavigationPath
    
    @State var wordInput: String = ""
    @FocusState private var isFocused: Bool
    @State var editing: Bool = false
    
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Напишите правильный перевод слова")
                .ruleTextModifier()
            
            Text(word.original)
                .wordTextModifier(color: .mainGreen)
            
            
            AcceptButtonView(testViewModel: testViewModel, word: word)
                .focused($isFocused)
        }
        .padding(.top, 20)
        .frame(height: 500)
        .frame(maxHeight: .infinity)
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = false
            editing = false
        }
        
    }
}

