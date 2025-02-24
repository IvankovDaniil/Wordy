//
//  WordModel.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 21.02.2025.
//

import Foundation
import SwiftData

enum Language: String, Codable {
    case english, italian, french
}

@Model
class Word {
    @Attribute(.unique) var original: String
    var translation: String
    
    init(original: String, translation: String) {
        self.original = original
        self.translation = translation
    }
}
