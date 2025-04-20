//
//  AllWordsFlow.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 24.02.2025.
//

import SwiftUI


struct AllWordsFlow: View {
    @Bindable var viewModel: WordViewModel

    @AppStorage("selectedLanguage") private var selectedLanguageRaw: String = Language.english.rawValue
    @State private var transitionDirection: CGFloat = 0
    @Namespace private var animation

    private var selectedLanguage: Language {
        get { Language(rawValue: selectedLanguageRaw) ?? .english }
        set { selectedLanguageRaw = newValue.rawValue }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AllWordsView(viewModel: viewModel)
                    .id(selectedLanguage)
                    .transition(.asymmetric(
                        insertion: .move(edge: transitionDirection > 0 ? .leading : .trailing),
                        removal: .move(edge: transitionDirection > 0 ? .trailing : .leading))
                    )
            }
            .animation(.easeInOut(duration: 0.3), value: selectedLanguageRaw)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width > 75 {
                            transitionDirection = -1
                            selectedLanguageRaw = selectedLanguage.previous().rawValue
                        } else if value.translation.width < -75 {
                            transitionDirection = 1
                            selectedLanguageRaw = selectedLanguage.next().rawValue
                        }
                    }
            )
        }
    }
}

extension Language {
    static var all: [Language] { allCases }
    
    func next() -> Language {
        guard let index = Self.all.firstIndex(of: self) else { return self }
        
        let nextIndex = (index + 1) % Self.all.count
        return Self.all[nextIndex]
    }
    
    func previous() -> Language {
        guard let index = Self.all.firstIndex(of: self) else { return self }
        
        let previousIndex = (index - 1 + Self.all.count) % Self.all.count
        return Self.all[previousIndex]
    }
}
