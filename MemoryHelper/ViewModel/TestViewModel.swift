//
//  TestViewModel.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 28.02.2025.
//

import Foundation

enum TestType {
    case spellWord, chooseRightTranslate, listenAndType
}

@Observable
final class TestViewModel {
    private let wordsViewModel: WordViewModel
    
    private var testWord: [(word: Word, test: TestType)] = []
    var currentWord: Word?
    var currentType: TestType?
    var currentIndex: Int = 0
    
    init(wordsViewModel: WordViewModel) {
        self.wordsViewModel = wordsViewModel
        self.setup()
    }
    
    func setup() {
        let shuffledWords = wordsViewModel.words.shuffled()
        let testCases: [TestType] = [.spellWord, .chooseRightTranslate, .listenAndType]
        
        for shuffledWord in shuffledWords {
            testWord.append((shuffledWord, testCases.randomElement()!))
        }
        
        loadNextTest()
        
    }
    
    func nextTest() {
        guard currentIndex < testWord.count else { return }
        
        currentIndex += 1
        loadNextTest()
    }
    
    func loadNextTest() {
        currentType = testWord[currentIndex].test
        currentWord = testWord[currentIndex].word
    }
}
