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
    
    private let speechManager = SpeechManager(language: "en-US")
    
    @State var wordInput: String = ""
    @FocusState private var isFocused: Bool
    @State var editing: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 20) {
                Text("Прослушайте и напишите правильно слово")
                    .ruleTextModifier()
                
                Image(systemName: "speaker.wave.3.fill")
                    .wordTextModifier()
                    .onTapGesture {
                        speechManager.speak(text: word.translation)
                    }
                
                AcceptButtonView(testViewModel: testViewModel, word: word)
                    .focused($isFocused)
            }
            .frame(height: 500)
            .frame(maxHeight: .infinity)
        }
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
    let language: String
    
    init(language: String) {
        self.language = language
    }
    
    deinit {
        print("speech Deinit")
    }
    
    func speak(text: String) {
        speechManager.stopSpeaking(at: .immediate)
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        
        speechManager.speak(utterance)
    }
}
