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
    case unknown
    case noInternet
    case decodingError
    
    var errorDesription: String {
        switch self {
        case .badURL:
            "Неверный URL"
        case .badRequest:
            "Ошибка запроса"
        case .unknown:
            "Неизвестная ошибка"
        case .noInternet:
            "Нет подключения к интернету"
        case .decodingError:
            "Ошибка в получении данных"
        }
    }
}

final class Networking {
    private let baseURL: URL? = URL(string: "https://translate.api.cloud.yandex.net/translate/v2/translate")
    private let apiKey = YandexAPI.apiKey
    private let detectCodeURL: URL? = URL(string: "https://translate.api.cloud.yandex.net/translate/v2/detect")
    private let idFolder = YandexAPI.idFolder
    
    func translateWordWithAPI(_ word: String, _ sourceLanguaggeCode: String, _ targetLanguageCode: String) async throws -> String {
        
        guard let url = baseURL else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Api-Key \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let httpBody: [String : Any] = [
            "sourceLanguageCode": sourceLanguaggeCode ,
            "targetLanguageCode": targetLanguageCode,
            "texts": ["\(word)"]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: httpBody)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.badRequest
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(TranslationResponse.self, from: data)
                return decodedResponse.translations.first?.text ?? "Ошибка"
            } catch {
                throw NetworkError.decodingError
            }

        } catch {
            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                throw NetworkError.noInternet
            } else {
                throw NetworkError.unknown
            }
        }

    }
    
    func findLanguageCode(_ word: String, _ languageCode: String) async throws -> String {
        guard let url = detectCodeURL else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Api-Key \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let httpBody: [String : Any] = [
            "folderId": "\(idFolder)",
            "languageCodeHints":["ru", "\(languageCode)"],
            "text": "\(word)"
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: httpBody)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.badRequest
            }
            
            let decodeResponse = try JSONDecoder().decode(DetectedCode.self, from: data)
            return decodeResponse.languageCode
        } catch {
            throw NetworkError.noInternet
        }

    }
}

//MARK: TranslationDTO
struct TranslationResponse: Codable {
    var translations: [Translations]
    
    struct Translations: Codable {
        let text: String
    }
}

//MARK: DetectedCodeDTO
struct DetectedCode: Codable {
    var languageCode: String
}
