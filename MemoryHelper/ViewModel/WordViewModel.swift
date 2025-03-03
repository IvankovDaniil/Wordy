//
//  WordViewModel.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 24.02.2025.
//

import Foundation
import SwiftData

protocol WordsManaging: AnyObject {
    var words: [Word] { get }
    func addWord(_ word: Word)
    func deleteWord(_ word: Word)
    func updateWord(at index: Int, with word: Word)
}

@Observable
final class WordViewModel: WordsManaging {
    
    private var modelContext: ModelContext

    private(set) var words: [Word] = []

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchWords()
    }
    
    //Загрузка первых слов для английского языка
    func preloadWords() {
        let defaultWords = [
            Word(original: "Семья", translation: "Family"),
            Word(original: "Любовь", translation: "Love"),
            Word(original: "Мама", translation: "Mom"),
            Word(original: "Привет", translation: "Hello"),
            Word(original: "Пока", translation: "Bye"),
            Word(original: "Спасибо", translation: "Thank you"),
            Word(original: "Конечно", translation: "Of course"),
            Word(original: "Удачи", translation: "Good luck"),
            Word(original: "Время", translation: "Time"),
            Word(original: "Дом", translation: "Home"),
            Word(original: "Холодильник", translation: "Fridge"),
            Word(original: "Маркетолог", translation: "Marketolog"),
        ]
        
        for word in defaultWords {
            modelContext.insert(word)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Ошибка добавления начальных слов")
        }
        
        words = defaultWords
    }
    
    //Загрузка слов при запуске приложения на английском языке
    func fetchWords() {
        let descriptor = FetchDescriptor<Word>()
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "preloadWords")
        
        if let storedWords = try? modelContext.fetch(descriptor), isFirstLaunch {
            words = storedWords
        } else {
            preloadWords()
            UserDefaults.standard.set(true, forKey: "preloadWords")
        }
    }

    func addWord(_ word: Word) {
        words.append(word)
    }
    
    func deleteWord(_ word: Word) {
        if let index = words.firstIndex(where: { $0.original == word.original && $0.translation == word.translation }) {
            words.remove(at: index)
        }
    }
    
    func updateWord(at index: Int, with word: Word) {
        guard words.indices.contains(index) else {
            return
        }
        
        words[index] = word
    }
    
    func conditionForLockMenu() -> LockUnlockMenu {
        words.count > 4 ? .unlock : .lock
    }
    
}
