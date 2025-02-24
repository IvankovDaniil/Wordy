//
//  MainMenu.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 21.02.2025.
//

import SwiftUI

struct MainMenu: View {
    
    private let buttons: [ButtonMenuConfiguration] = [
        ButtonMenuConfiguration(id: 1, title: "Все слова", image: "📖"),
        ButtonMenuConfiguration(id: 2, title: "Тест", image: "🎯")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            TitleMenu()
            Spacer()
            ButtonMenu(buttons: buttons)
            Spacer()
        }
        .frame(maxWidth: .infinity ,maxHeight: .infinity)
        .background {
            Image(.bg)
                .opacity(0.1)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

private struct TitleMenu: View {
    let title = "Запоминатор"
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.custom("Arial", size: 35))
                .bold()
                .padding(.horizontal, 40)
            
            Button {
                //
            } label: {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .foregroundStyle(.black)
                    .frame(width: 25, height: 25)
            }

        }
    }
}

private struct ButtonMenu: View {
    var buttons: [ButtonMenuConfiguration]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(buttons) { button in
                ButtonMenuView(button: button)
                    .padding(.vertical, 15)
            }
        }
    }
}

private struct ButtonMenuView: View {
    let button: ButtonMenuConfiguration
    
    var body: some View {
        HStack(alignment: .center,spacing: 0) {
            Button {
                
            } label: {
                HStack {
                    Text(button.image)
                    Text(button.title)
                }
                .frame(width: 280, height: 40)
            }
            .foregroundStyle(.black)
            .font(.custom("Arial", size: 22))
            .padding(.vertical, 15)
            .background(.white)
        }
        .clipShape(.rect(cornerRadius: 15))
        .shadow(color: .gray, radius: 5, x: 5, y: 5)
    }
}

private struct ButtonMenuConfiguration: Identifiable {
    let id: Int
    let title: String
    let image: String
}

#Preview {
    MainMenu()
}
