//
//  SettingsView.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 30.03.2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedLanguage") private var selectedLanguageRaw: String = Language.english.rawValue
    var selectedLanguage: Language {
        get { Language(rawValue: selectedLanguageRaw) ?? .english }
        set { selectedLanguageRaw = newValue.rawValue }
    }
    
    @AppStorage("isHapticsEnable") var isVibro: Bool = true
    @AppStorage("isMusicEnable") var isMusicEnable: Bool = true
    
    var body: some View {
        ScrollView {
            VStack() {
                VStack(spacing: 5) {
                    Image(.wordyLogo)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(.rect(cornerRadius: 30))
                        .shadow(radius: 6, x: 5, y: 5)
                    
                    Text("Wordy v1.0")
                        .font(.custom("Arial Black", size: 16))
                        .foregroundStyle(.gray)
                    
                    Text("© 2025")
                        .font(.custom("Arial", size: 14))
                        .foregroundStyle(.gray)
                }
                
                
                VStack {
                    Text("Язык")
                    Picker("Язык", selection: $selectedLanguageRaw) {
                        ForEach(Language.allCases, id: \.self) { language in
                            Text(language.rawValue)
                                .tag(language.rawValue)
                        }
                    }
                    .foregroundStyle(.white)
                    .tint(.white)
                    .pickerStyle(.segmented)
                }
                .font(.custom("Arial Black", size: 22))
                .foregroundStyle(.white)
                .padding()
                .background(.mainGreen)
                .clipShape(.rect(cornerRadius: 20))
                .padding(.top, 40)
                
                VStack {
                    Toggle("Вибрация", isOn: $isVibro)
//                        .onChange(of: isVibro) { newValue, _ in
//                            print("MY LOG: User toggled music to", newValue)
//                            UserDefaults.standard.set(newValue, forKey: "isHapticsEnable")
//                            UserDefaults.standard.synchronize()
//                        }
                    Toggle("Звуки", isOn: $isMusicEnable)
//                        .onChange(of: isMusicEnable) { newValue, _ in
//                            print("MY LOG: User toggled music to", newValue)
//                            UserDefaults.standard.set(newValue, forKey: "isMusicEnable")
//                            UserDefaults.standard.synchronize()
//                        }
                }
                .toggleStyle(.switch)
                .tint(.mainViolet)
                .font(.custom("Arial Black", size: 22))
                .foregroundStyle(.white)
                .padding()
                .background(.mainGreen)
                .clipShape(.rect(cornerRadius: 20))
            }
        }
        .padding()
    }
}
