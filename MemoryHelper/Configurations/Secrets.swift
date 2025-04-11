//
//  Secrets.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 10.04.2025.
//
import Foundation

enum YandexAPI {
    static let apiKey = Bundle.main.infoDictionary?["YANDEX_API_KEY"] as? String ?? ""
    static let idFolder = Bundle.main.infoDictionary?["ID_FOLDER"] as? String ?? ""
}
