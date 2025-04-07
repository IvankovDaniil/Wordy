//
//  WordModel.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 21.02.2025.
//

import Foundation
import SwiftData

enum Language: String, Codable, CaseIterable {
    case english = "Английский"
    case italian = "Итальянский"
    case french = "Французский"
    
    var code: String {
        switch self {
        case .english:
            "en"
        case .italian:
            "it"
        case .french:
            "fr"
        }
    }
}

@Model
class Word {
    var original: String
    var translation: String
    var language: String
    
    init(original: String, translation: String, language: String) {
        self.original = original
        self.translation = translation
        self.language = language
    }
}

struct WordList: Codable {
    var english: [WordData]
    var italian: [WordData]
    var french: [WordData]
}

struct WordData: Codable {
    let original: String
    let translation: String
}
