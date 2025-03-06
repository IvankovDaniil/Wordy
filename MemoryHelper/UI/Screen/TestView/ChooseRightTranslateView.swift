//
//  ChooseRightTranslateView.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 06.03.2025.
//

import SwiftUI


struct ChooseRightTranslateView: View {
    let testViewModel: TestViewModel
    let word: Word
    private let randomBool = Bool.random()
    @State private var selectedWord: Word?
    @State var testWords: [Word] = []
    
    init(testViewModel: TestViewModel, word: Word) {
        self.testViewModel = testViewModel
        self.word = word
    }
    
    var body: some View {
        
        VStack(spacing: 40) {
            Spacer()
            Text("Выберите правильный перевод слова")
            Text(randomBool ? word.original : word.translation)
                .font(.custom("Arial", size: 30))
                .padding()
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            
            HStack(spacing: 0) {
                ForEach(testWords) { testWord in
                    
                    Button {
                        selectedWord = testWord
                        
                        if selectedWord == self.word {
                            testViewModel.isRightWord = true
                        } else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                selectedWord = nil
                            }
                        }
                    } label: {
                        Text(randomBool ? testWord.translation : testWord.original)
                            .font(.custom("Arial", size: 22))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background (
                                selectedWord == testWord
                                ? (testWord == word ? .green : .red )
                                : Color(.gray).opacity(0.3)
                            )
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .disabled(selectedWord != nil)
                }
                .padding(10)
            }
            
            Spacer()
            
            VStack {
                if testViewModel.isRightWord {
                    NextTestButtonView(testViewModel: testViewModel)
                    onTapGesture {
                        selectedWord = nil
                    }
                }
            }
            .frame(height: 100)
            .animation(.easeInOut(duration: 0.3), value: testViewModel.isRightWord)
            
            Spacer()
            
        }
        .navigationTitle("Выбери правильный")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.testWords = self.testViewModel.randomWords(rightWord: word)
        }
    }
}
