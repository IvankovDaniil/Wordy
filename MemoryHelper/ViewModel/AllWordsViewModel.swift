//
//  AllWordsViewModel.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 24.02.2025.
//

import Foundation
import UIKit


final class AllWordsViewModel {
    
    //Расчет максимальной длины слова
    func maxWordWidth(_ word: Word) -> CGFloat {
        let font = UIFont(name: "Arial", size: 24) ?? UIFont.systemFont(ofSize: 24)
        let attribution: [NSAttributedString.Key : Any] = [.font : font]
        
        let translationWidth = (word.translation as NSString).size(withAttributes: attribution).width
        let originalWidth = (word.original as NSString).size(withAttributes: attribution).width
        return max(translationWidth, originalWidth)
    }
    
    
    func arrangeWordsIntoRow(_ words: [Word], maxWidth: CGFloat) -> [[Word]] {
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


//var rows: [[Word]] = []
//var currentRow: [Word] = []
//var currentWidth: CGFloat = 0
//
//for word in words {
//    let wordWidth = word.maxWidth() + 20  // Максимальная ширина + padding
//    
//    if currentWidth + wordWidth + 10 > maxWidth {
//        rows.append(currentRow)
//        currentRow = []
//        currentWidth = 0
//    }
//    
//    currentRow.append(word)
//    currentWidth += wordWidth + 10
//}
//
//if !currentRow.isEmpty {
//    rows.append(currentRow)
//}
//
//return rows
