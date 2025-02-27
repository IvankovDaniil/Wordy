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
    var wordsViewodel: WordViewModel
    
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
}
