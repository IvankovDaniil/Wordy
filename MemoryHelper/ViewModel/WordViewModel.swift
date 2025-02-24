//
//  WordViewModel.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 24.02.2025.
//

import Foundation
import SwiftData

@Observable
final class WordViewModel {
    private var modelContext: ModelContext
    
    var words: [Word] = []
    var newWord: String = ""

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchWords()
    }
    
    //Загрузка первыйх слов для английского языка
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
            Word(original: "Дом", translation: "Home")
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
    

}
