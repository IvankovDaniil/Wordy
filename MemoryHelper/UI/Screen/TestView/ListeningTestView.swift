//
//  ListeningTestView.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 14.03.2025.
//

import SwiftUI
import AVFoundation

struct ListeningTestView: View {
    @Bindable var testViewModel: TestViewModel
    let word: Word
    @AppStorage("selectedLanguage") var selectedLanguageRaw: String = Language.english.rawValue
    private var selectedLanguage: Language {
        get { Language(rawValue: selectedLanguageRaw) ?? .english }
        set { selectedLanguageRaw = newValue.rawValue }
    }
    
    private let speechManager = SpeechManager(/*language: selectedLanguage*/)
    
    @State var wordInput: String = ""
    @FocusState private var isFocused: Bool
    @State var editing: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Прослушайте и напишите правильно слово")
                .ruleTextModifier()
            
            Image(systemName: "speaker.wave.3.fill")
                .wordTextModifier(color: .mainGreen)
                .onTapGesture {
                    speechManager.speak(text: word.translation, language: selectedLanguage)
                }
            
            AcceptButtonView(testViewModel: testViewModel, word: word)
                .focused($isFocused)
        }
        .padding(.top, 5)
        .frame(height: 500)
        .frame(maxHeight: .infinity)
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = false
            editing = false
        }
        
    }
}

private final class SpeechManager {
    let speechManager: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    func speak(text: String, language: Language) {
        let languageCode = {
            switch language {
            case .english:
                return "en-US"
            case .italian:
                return "it-IT"
            case .french:
                return "fr-FR"
            }
        }()
        
        speechManager.stopSpeaking(at: .immediate)
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        
        speechManager.speak(utterance)
    }
}
