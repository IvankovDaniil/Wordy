//
//  ChooseRightTranslateView.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 06.03.2025.
//

import SwiftUI

struct ChooseRightTranslateView: View {
    @Bindable var testViewModel: TestViewModel
    let word: Word
    @State private var randomBool = Bool.random()
    @State private var selectedWord: Word?
    @State var testWords: [Word] = []
    //@Binding var path: NavigationPath
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Выберите правильный перевод слова")
                .ruleTextModifier()
            
            Text(randomBool ? word.original : word.translation)
                .wordTextModifier(color: .mainGreen)
            
            GeometryReader { geometry in
                let buttonWidth = (geometry.size.width - 32) / CGFloat(testWords.count)
                let buttonFontSize = max(16, (geometry.size.width * 0.05))
                
                
                HStack(spacing: 15) {
                    ForEach(testWords) { testWord in
                        Button(action: {
                            let generator = UINotificationFeedbackGenerator()
                            generator.prepare()
                            selectedWord = testWord
                            if selectedWord == self.word {
                                testViewModel.isRightWord = true
                                generator.notificationOccurred(.success)
                            } else {
                                generator.notificationOccurred(.error)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    selectedWord = nil
                                }
                            }
                        }) {
                            Text(randomBool ? testWord.translation : testWord.original)
                                .font(.custom("Arial", size: buttonFontSize))
                                .frame(width: buttonWidth, height: 50)
                                .background(
                                    selectedWord == testWord
                                    ? (testWord == word ? Color.green : Color.red)
                                    : Color.gray.opacity(0.3)
                                )
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .foregroundColor(.white)
                        }
                        .disabled(selectedWord != nil)
                    }
                }
            }
            //.padding(.trailing, 16)
            .frame(height: 60)
           
            
            
            NextTestButtonView(selectedWord: $selectedWord, isRightWord: $testViewModel.isRightWord, action: {
                testViewModel.nextTest()
//                path.append(testViewModel.currentType)
            })
            .transition(.opacity)
            .opacity(testViewModel.isRightWord ? 1 : 0)
            .clipped()
        }
        .padding(.top, 32)
        .frame(height: 500)
        .frame(maxHeight: .infinity)
        .padding()
//        .contentShape(Rectangle())
        .onAppear {
            self.testWords = self.testViewModel.randomWords(rightWord: word)
        }
        .onChange(of: word) { newValue, oldValue in
            self.testWords = self.testViewModel.randomWords(rightWord: word)
        }
        
    }
}

