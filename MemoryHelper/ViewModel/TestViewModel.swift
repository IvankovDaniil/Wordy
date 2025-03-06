//
//  TestViewModel.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 28.02.2025.
//

import Foundation

enum TestType {
    case freeInput, chooseRightTranslate, listenAndType
}

@Observable
final class TestViewModel {
    private let wordsViewModel: WordViewModel
    
    var testWord: [(word: Word, test: TestType)] = []
    var currentWord: Word?
    var currentType: TestType?
    var currentIndex: Int = 0
    var isRightWord: Bool = false
    var isValid: Bool?
    
    init(wordsViewModel: WordViewModel) {
        self.wordsViewModel = wordsViewModel
        self.setup()
    }
    
    func setup() {
        let shuffledWords = wordsViewModel.words.shuffled()
        let testCases: [TestType] = [.freeInput, .chooseRightTranslate, .listenAndType]
        
        for shuffledWord in shuffledWords {
            testWord.append((shuffledWord, testCases.randomElement()!))
        }
        
        loadNextTest()
        
    }
    
    func nextTest() {
        guard currentIndex < testWord.count else { currentType = nil; return }
        
        currentIndex += 1
        loadNextTest()
    }
    
    func loadNextTest() {
        currentType = testWord[currentIndex].test
        currentWord = testWord[currentIndex].word
    }
    
    func randomWords(rightWord: Word) -> [Word] {
        var options: Set<Word> = [rightWord]

         while options.count < 3 {
             if let randomWord = wordsViewModel.words.randomElement(), randomWord != rightWord {
                 options.insert(randomWord)
             }
         }

         return options.shuffled()
    }
    
    
    
    func freeInputWordCheck(word: String) {
        guard let currentWord = currentWord else {
            return
        }
        
        isValid = true
        
        if currentWord.translation.lowercased() == word.lowercased() {
            isRightWord = true
            isValid = nil
        } else {
            isValid = false
        }
    }
}
