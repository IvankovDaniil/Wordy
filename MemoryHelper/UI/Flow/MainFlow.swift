//
//  MainFlow.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 21.02.2025.
//

import SwiftUI
import SwiftData
import UIKit

enum TabBarFlow {
    case test, allWords, settings
}

struct MainFlow: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var viewModel: WordViewModel
    @State var currentTab: TabBarFlow = .allWords
    @AppStorage("selectedLanguage") var selectedLanguageRaw: String = Language.english.rawValue
    private var selectedLanguage: Language {
        get { Language(rawValue: selectedLanguageRaw) ?? .english }
        set { selectedLanguageRaw = newValue.rawValue}
    }
    
    private let buttons: [ButtonMenuConfiguration] = [
        ButtonMenuConfiguration(title: "ВСЕ СЛОВА", icon: "book.fill", tab: .allWords),
        ButtonMenuConfiguration(title: "ТЕСТ", icon: "brain.filled.head.profile", tab: .test),
        ButtonMenuConfiguration(title: "НАСТРОЙКИ", icon: "gearshape.fill", tab: .settings),

    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                switch currentTab {
                case .allWords:
                    AllWordsFlow(viewModel: viewModel)
                case .test:
                    TestFlow(words: viewModel.setTestWords(for: selectedLanguage))
                case .settings:
                    SettingsView()
                }
                
                TabBarLabel(buttons: buttons, currentTab: $currentTab)
                    .padding(.top, 10)
                    .background {
                        BlurView(style: .systemThinMaterial)
                            .ignoresSafeArea()
                    }
            }
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

private struct ButtonMenuConfiguration: Identifiable {
    var id: TabBarFlow { tab }
    let title: String
    let icon: String
    let tab: TabBarFlow
}


private struct TabBarLabel: View {
    let buttons: [ButtonMenuConfiguration]
    @Binding var currentTab: TabBarFlow
    
    @State private var indicatorPosition: CGFloat = 0
    @State private var indicatorWidth: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 30)
                .fill(.mainViolet)
                .padding(.horizontal, 12)
                .frame(width: indicatorWidth)
                .offset(x: indicatorPosition)
                .animation(.easeInOut(duration: 0.3), value: indicatorPosition)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 0) {
                ForEach(buttons) { button in
                    TabBarButtons(config: button, isSelected: button.tab == currentTab, action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentTab = button.tab
                            updateIndicator(for: button)
                        }
                    })
                }
            }
        }
        .frame(height: 60)
        .onAppear {
            updateIndicator(for: buttons.first(where: { $0.tab == currentTab }) ?? buttons.first!)
        }
    }
    
    private func updateIndicator(for button: ButtonMenuConfiguration) {
        if let buttonIndex = buttons.firstIndex(where: { $0.tab == button.tab }) {
            let width = UIScreen.main.bounds.width / CGFloat(buttons.count)
            let position = CGFloat(buttonIndex) * width
            indicatorPosition = position
            indicatorWidth = width
        }
    }
}

private struct TabBarButtons: View {
    let config: ButtonMenuConfiguration
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 0) {
                Image(systemName: config.icon)
                    .font(.title2)
                    .foregroundStyle(isSelected ? .white : .mainGreen)
                    .padding(.top, 5)
                
                Text(config.title)
                    .font(.custom("Arial Black", size: 10))
                    .foregroundColor(isSelected ? .white : .mainViolet)
                    .padding(.bottom, 5)
            }
            .frame(maxWidth: .infinity, maxHeight: 60)
        }
    }
}



struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
    
    
}
