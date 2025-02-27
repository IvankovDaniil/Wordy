//
//  Networking.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 26.02.2025.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badRequest
}

final class Networking {
    private let baseURL: URL? = URL(string: "https://translate.api.cloud.yandex.net/translate/v2/translate")
    private let apiKey = "AQVN0pISHwA4WHj0aWMZ6VZFtFhGVWhWHxrq05mh"
    
    func translateWordWithAPI(_ word: String) async throws -> String {
        
        guard let url = baseURL else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Api-Key \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let httpBody: [String : Any] = [
            "sourceLanguageCode": "ru",
            "targetLanguageCode": "en",
            "texts": ["\(word)"]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: httpBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        
        let decodedResponse = try JSONDecoder().decode(TranslationResponse.self, from: data)
        return decodedResponse.translation.first?.text ?? "Ошибка"
    }
}

//MARK: TranslationDTO
struct TranslationResponse: Codable {
    var translation: [Translation]
    
    struct Translation: Codable {
        let text: String
    }
}
