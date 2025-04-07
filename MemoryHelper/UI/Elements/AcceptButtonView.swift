//
//  AcceptButtonView.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 03.04.2025.
//
import SwiftUI

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
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                
                if testViewModel.isRightWord {
                    testViewModel.isRightWord = false
                    testViewModel.nextTest()
                    //path.append(testViewModel.currentType)
                    wordInput = ""
                } else {
                    print("MY LOG: До метода: ", word.translation)
                    testViewModel.freeInputWordCheck(word: wordInput)
                    if testViewModel.isRightWord {
                        generator.notificationOccurred(.success)
                    } else {
                        generator.notificationOccurred(.error)
                    }
                    print("MY LOG: после: ", word.translation)
                    isFocused = false
                }
            } label: {
                Text(testViewModel.isRightWord ? "Следующий вопрос" : "Проверить")
                    .font(.custom("Arial Black", size: 24))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.mainViolet)
                    .cornerRadius(12)
            }
            
            Text("Правильно! 🎉")
                .font(.custom("Arial", size: 20))
                .foregroundColor(.green)
                .transition(.opacity)
                .padding(.top, 10)
                .opacity(testViewModel.isRightWord ? 1.0 : 0.0)
                .clipped()
        }
    }
}
