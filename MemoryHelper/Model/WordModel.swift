//
//  WordModel.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 21.02.2025.
//

import Foundation

enum Language: String, Codable {
    case english, italian, french
}

struct Word: Identifiable, Codable {
    let id: Int
    let original: String
    let translation: String
    let language: Language
}
