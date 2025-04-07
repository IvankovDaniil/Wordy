//
//  AllWordsViewModel.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 24.02.2025.
//

import Foundation
import UIKit
import SwiftUI

@Observable
final class AllWordsViewModel {
    var wordsViewodel: WordsManaging
    private var networking = Networking()
    var newWord: String = ""
    let selectedLanguage: Language
    
    var selectedWords = [Word]()
    
    init(wordsViewodel: WordViewModel, selectedLanguage: Language) {
        self.wordsViewodel = wordsViewodel
        self.selectedLanguage = selectedLanguage
    }
    
    var words: [Word] {
        wordsViewodel.words.filter { $0.language == selectedLanguage.code }
    }
    
    //Расчет максимальной длины слова
    func maxWordWidth(_ word: Word) -> CGFloat {
        let font = UIFont(name: "Arial", size: 24) ?? UIFont.systemFont(ofSize: 24)
        let attribution: [NSAttributedString.Key : Any] = [.font : font]
        
        let translationWidth = (word.translation as NSString).size(withAttributes: attribution).width
        let originalWidth = (word.original as NSString).size(withAttributes: attribution).width
        return max(translationWidth, originalWidth)
    }
    
    //Расчет сколько слов поместятся в одну строку
    func arrangeWordsIntoRow(maxWidth: CGFloat) -> [[Word]] {
        var rows: [[Word]] = []
        var currentRows = [Word]()
        var currentWidth: CGFloat = 0
        
        for word in words {
            let maxWordWidth = maxWordWidth(word) + 20
            
            if currentWidth + maxWordWidth + 20 > maxWidth {
                rows.append(currentRows)
                
                currentRows = []
                currentWidth = 0
            }
            
            currentRows.append(word)
            currentWidth += maxWordWidth + 10
        }
        
        if !currentRows.isEmpty {
            rows.append(currentRows)
        }
        
        return rows
    }
    
    //Добавление нового слова
    func addNewWord(_ word: String) {
        
        let newFilteredWordWord = filterWord(word)
        
        guard newFilteredWordWord != "" else {
            return
        }
        
        guard !words.contains(where: { $0.original == word }) else {
            return
        }
        
        let placeholder = Word(original: "\(newFilteredWordWord)", translation: "Переводим...", language: selectedLanguage.code)
        wordsViewodel.addWord(placeholder)
        
        Task {
            do {
                let detectionCode = try await networking.findLanguageCode(newFilteredWordWord, selectedLanguage.code)
                let isRussian = detectionCode == "ru"
                
                let translate = try await networking.translateWordWithAPI(
                    newFilteredWordWord,
                    isRussian ? "ru" : "\(selectedLanguage.code)",
                    isRussian ? "\(selectedLanguage.code)" : "ru"
                )
                
                let newWord = Word(
                    original: isRussian ? newFilteredWordWord : translate,
                    translation: isRussian ? translate : newFilteredWordWord,
                    language: selectedLanguage.code
                )
                
                if let index = wordsViewodel.words.firstIndex(where: { $0.translation == "Переводим..." }) {
                    wordsViewodel.updateWord(at: index, with: newWord)
                }
            } catch {
                print("Error \(error)")
            }
        }
        
        newWord = ""
        
        func filterWord(_ word: String) -> String {
            let filtered = word.filter { $0.isLetter || $0 == " " || $0 == "-" }
            let filteredWord = filtered.split(separator: " ", omittingEmptySubsequences: true).joined(separator: " ")
            return String(filteredWord.prefix(30))
        }
    }
    
    // Выбор/отмена выбора слова
    func toggleSelection(for word: Word) {
        if let index = selectedWords.firstIndex(where: { $0.id == word.id }) {
            selectedWords.remove(at: index)
        } else {
            selectedWords.append(word)
        }
    }
    
    //Удаление слова
    func deleteWord() {
        guard !selectedWords.isEmpty else { return }
        
        withAnimation {
            wordsViewodel.deleteWord(selectedWords)
            selectedWords.removeAll()
        }
    }
    
}
