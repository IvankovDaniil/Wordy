//
//  MainMenu.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 21.02.2025.
//

import SwiftUI

enum LockUnlockMenu {
    case lock, unlock
}

struct MainMenu: View {
    @Bindable var viewModel: WordViewModel
    
    
    var body: some View {
        let buttons: [ButtonMenuConfiguration] = [
            ButtonMenuConfiguration(id: 1, title: "Все слова", image: "📖", destination: AnyView(AllWordsFlow(viewModel: viewModel)), isLocked: .unlock),
            ButtonMenuConfiguration(id: 2, title: "Тест", image: "🎯", destination: AnyView(TestFlow(viewModel: viewModel)), isLocked: viewModel.conditionForLockMenu())
        ]
        
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
    var isLock: Bool {
        button.isLocked == .lock
    }
    @State private var showMessage = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ZStack {
                NavigationLink(destination: button.destination) {
                    HStack {
                        Text(button.image)
                        Text(button.title)
                    }
                    .opacity(isLock ? 0.5 : 1)
                    .frame(width: 280, height: 40)
                }
                .disabled(isLock)
                
                if isLock {
                    Image(systemName: "lock.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
            .simultaneousGesture(TapGesture().onEnded {
                if isLock {
                    showMessage = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            showMessage = false
                        }
                    }
                }
            })
        }
        .foregroundStyle(.black)
        .font(.custom("Arial", size: 22))
        .padding(.vertical, 15)
        .background(.white)
        .clipShape(.rect(cornerRadius: 15))
        .shadow(color: .gray, radius: 5, x: 5, y: 5)
        .overlay {
            if showMessage {
                ShowMessageTextView(showMessage: showMessage)
            }
        }
    }
}

private struct ShowMessageTextView: View {
    let showMessage: Bool
    
    var body: some View {
        Text("У вас в словаре должно быть как минимум 5 слов для открытия теста")
            .foregroundColor(.white)
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(10)
            .offset(y: -50)
            .opacity(showMessage ? 1 : 0)
            .animation(.easeInOut(duration: 0.3), value: showMessage)
    }
}

private struct ButtonMenuConfiguration: Identifiable {
    let id: Int
    let title: String
    let image: String
    let destination: AnyView
    let isLocked: LockUnlockMenu
}
