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
    func deleteWords(_ word: [Word])
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
    
    
    func resetWords() {
        let descriptor = FetchDescriptor<Word>()
        
        if let storedWords = try? modelContext.fetch(descriptor) {
            for word in storedWords {
                modelContext.delete(word)
            }
            try? modelContext.save()
        }
        
        UserDefaults.standard.set(false, forKey: "preloadWords")
    }
    
    //Загрузка первых слов для английского языка
    func preloadWords() {
        
        guard let url = Bundle.main.url(forResource: "words", withExtension: "json") else {
            print("error json read")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let wordList = try JSONDecoder().decode(WordList.self, from: data)
            
            for word in wordList.english {
                modelContext.insert(Word(original: word.original, translation: word.translation, language: "en"))
            }
            
            for word in wordList.french {
                modelContext.insert(Word(original: word.original, translation: word.translation, language: "fr"))
            }
            
            for word in wordList.italian {
                modelContext.insert(Word(original: word.original, translation: word.translation, language: "it"))
            }
            
            try modelContext.save()
            
            let descriptor = FetchDescriptor<Word>()
            if let storedWords = try? modelContext.fetch(descriptor) {
                words = storedWords
            }
            
        } catch {
            
        }
        
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
        modelContext.insert(word)
        do {
            try modelContext.save()
            fetchWords()
        } catch {
            print("Error with adding words")
        }
    }
    
    func deleteWords(_ words: [Word]) {
        
        for word in words {
            modelContext.delete(word)
        }
        
        do {
            try modelContext.save()
            fetchWords()
        } catch {
            print("Error with deleting words")
        }
    }
    
    func updateWord(at index: Int, with word: Word) {
        guard words.indices.contains(index) else {
            return
        }
        
        words[index].translation = word.translation
        words[index].original = word.original
        
        do {
            try modelContext.save()
            fetchWords()
        } catch {
            print("Error with update word")
        }
        
    }
    
    func setTestWords(for language: Language) -> [Word] {
        words.filter { $0.language == language.code }
    }
    
}
