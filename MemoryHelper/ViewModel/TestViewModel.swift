//
//  TestViewModel.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 28.02.2025.
//

import Foundation
import SwiftUI

enum TestType: String, CaseIterable {
    case freeInput = "Тренировка перевода"
    case chooseRightTranslate = "Тест на знание слов"
    case listenAndType = "Слушай и повторяй"
}

@Observable
final class TestViewModel: Equatable {
    static func == (lhs: TestViewModel, rhs: TestViewModel) -> Bool {
        return lhs.currentIndex == rhs.currentIndex && lhs.currentWord == rhs.currentWord
    }
    
    private var words: [Word]
    
    var testWord: [(word: Word, test: TestType)] = []
    var currentWord: Word?
    var currentType: TestType?
    var currentIndex: Int = 0
    var isRightWord: Bool = false
    var isValid: Bool?
    
    init(words: [Word]) {
        self.words = words
        self.setup()
    }
    
    func setup() {
        let shuffledWords = words.shuffled()
        let testCases: [TestType] = [.freeInput, .chooseRightTranslate, .listenAndType]
        
        for shuffledWord in shuffledWords {
            testWord.append((shuffledWord, testCases.randomElement()!))
        }
        
        loadNextTest()
        
    }
    
    func nextTest() {
        guard currentIndex < testWord.count - 1 else { currentType = nil; return }
        
        currentIndex += 1
        loadNextTest()
    }
    
    func loadNextTest() {
        let newWord = testWord[currentIndex].word
        
        currentType = testWord[currentIndex].test
        currentWord = newWord
    }
    
    func randomWords(rightWord: Word) -> [Word] {
        var options: Set<Word> = [rightWord]

         while options.count < 3 {
             if let randomWord = words.randomElement(), randomWord != rightWord {
                 options.insert(randomWord)
             }
         }

         return options.shuffled()
    }
    
    
    
    func freeInputWordCheck(word: String) {
        guard let currentWord = currentWord else {
            return
        }
        
        let cleanedWord = word
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .filter { $0.isLetter}
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: nil)
        
        let currentWordTranslation = currentWord.translation
        
        let currentWordCheck = currentWordTranslation
            .trimmingCharacters(in: .whitespaces)
            .filter { $0.isLetter }
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: nil)
        
        
        isValid = true
        
        if currentWordCheck == cleanedWord {
            isRightWord = true
            isValid = nil
        } else {
            isValid = false
        }
    }
    
    func isLock() -> Bool {
        self.words.count < 5
    }

}
