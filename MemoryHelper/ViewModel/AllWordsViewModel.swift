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
    var isAddingNewWord = false
    
    init(wordsViewodel: WordViewModel) {
        self.wordsViewodel = wordsViewodel
    }
    
    var words: [Word] {
        wordsViewodel.words
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
        
        guard word != "" else {
            isAddingNewWord = false
            return
        }
        
        guard !words.contains(where: { $0.original == word }) else {
            isAddingNewWord = false
            return
        }
        
        let placeholder = Word(original: "\(word)", translation: "Переводим...")
        wordsViewodel.addWord(placeholder)
        
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
                    wordsViewodel.updateWord(at: index, with: newWord)
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
        wordsViewodel.deleteWord(word)
    }
}
