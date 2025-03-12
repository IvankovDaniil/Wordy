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
    private let randomBool = Bool.random()
    @State private var selectedWord: Word?
    @State var testWords: [Word] = []
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Выберите правильный перевод слова")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text(randomBool ? word.original : word.translation)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(12)
                .shadow(radius: 5)
            
            GeometryReader { geometry in
                let buttonWidth = (geometry.size.width - 40) / CGFloat(testWords.count)
                
                HStack(spacing: 10) {
                    ForEach(testWords) { testWord in
                        Button(action: {
                            selectedWord = testWord
                            if selectedWord == self.word {
                                testViewModel.isRightWord = true
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    selectedWord = nil
                                }
                            }
                        }) {
                            Text(randomBool ? testWord.translation : testWord.original)
                                .font(.headline)
                                .frame(width: min(buttonWidth, 120), height: 50)
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
                .padding(.horizontal, 10)
            }
            .frame(height: 60)
            
            Spacer()
            
            NextTestButtonView(selectedWord: $selectedWord, isRightWord: $testViewModel.isRightWord, action: {
                testViewModel.nextTest()
            })
                    .transition(.opacity)
                    .opacity(testViewModel.isRightWord ? 1 : 0)
            
            
            Spacer()
        }
        .navigationTitle("Выбери правильный")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.testWords = self.testViewModel.randomWords(rightWord: word)
        }
        .onChange(of: word) { newValue, oldValue in
            self.testWords = self.testViewModel.randomWords(rightWord: word)
        }
    }
}

