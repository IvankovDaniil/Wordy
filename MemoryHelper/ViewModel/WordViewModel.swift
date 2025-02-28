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
    private var networking = Networking()
    
    var words: [Word] = []
    var newWord: String = ""
    var isAddingNewWord = false

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
    
    //Добавление нового слова
    func addNewWord(_ word: String) {
        
        guard word != "" else {
            isAddingNewWord = false
            return
        }
        
        words.append(Word(original: "\(word)", translation: "Переводим..."))
        
        Task {
            do {
                let detectionCode = try await networking.findLanguageCode(word)
                let isRussian = detectionCode == "ru"
                
                let translate = try await networking.translateWordWithAPI(
                    word,
                    isRussian ? "ru" : "en",
                    isRussian ? "en" : "ru"
                )
                
                let newWord = Word(
                    original: isRussian ? word : translate,
                    translation: isRussian ? translate : word
                )
                
                if let index = words.firstIndex(where: { $0.translation == "Переводим..." }) {
                    words[index] = newWord
                }
            } catch {
                print("Error \(error)")
            }
        }
        
        newWord = ""
        isAddingNewWord = false
    }
    
    //Удаление слова
    func deleteWord(_ word: Word) {
        if let index = words.firstIndex(where: { $0.translation == word.translation }) {
            words.remove(at: index)
        }
    }

}
