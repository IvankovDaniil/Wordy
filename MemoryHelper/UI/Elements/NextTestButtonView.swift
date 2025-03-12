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
        VStack() {
            Text("Правильно! 🎉")
                .font(.custom("Arial", size: 20))
                .foregroundColor(.green)
                .transition(.opacity)
            
            Button("Следующий") {
                withAnimation {
                    print("NextTestButton pressed")
                    selectedWord = nil
                    isRightWord = false
                    action()
                }
            }
            .font(.custom("Arial", size: 18))
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}
