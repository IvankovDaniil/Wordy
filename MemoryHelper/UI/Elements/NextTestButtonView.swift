//
//  NextTestButtonView.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 06.03.2025.
//
import SwiftUI

struct NextTestButtonView: View {
    let action: () -> Void
    @Binding var selectedWord: Word?
    @Binding var isRightWord: Bool
    
    init(selectedWord: Binding<Word?> = .constant(nil), isRightWord: Binding<Bool>, action: @escaping () -> Void) {
        self._selectedWord = selectedWord
        self._isRightWord = isRightWord
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button("Следующее слово") {
                withAnimation {
                    selectedWord = nil
                    isRightWord = false
                    action()
                }
            }
            .wordTextModifier(color: .mainViolet)
            
            Text("Правильно! 🎉")
                .font(.custom("Arial", size: 20))
                .foregroundColor(.green)
                .transition(.opacity)
                .padding(.top, 10)
        }
    }
}
