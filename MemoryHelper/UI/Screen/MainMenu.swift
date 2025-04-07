////
////  MainMenu.swift
////  MemoryHelper
////
////  Created by Даниил Иваньков on 21.02.2025.
////
//
import SwiftUI
//
//
//struct MainMenu: View {
//    @Binding var navigationPath: NavigationPath
//    @Bindable var viewModel: WordViewModel
//    @Binding var testViewModel: TestViewModel?
//
//    var body: some View {
//        ZStack() {
//            VStack(spacing: 0) {
//                TitleMenu()
//                Spacer()
//            }
//            .frame(maxHeight: .infinity)
//
//            ButtonMenu(viewModel: viewModel, navigationPath: $navigationPath, testViewModel: $testViewModel)
//        }
//        .frame(maxWidth: .infinity ,maxHeight: .infinity)
//        .background {
//            Image(.bg)
//                .opacity(0.05)
//        }
//    }
//}
//
//private struct TitleMenu: View {
//    let title = "WORD"
//    
//    var body: some View {
//        ZStack {
//            HStack {
//                Image("eyes")
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                    .padding(.leading)
//                Spacer()
//            }
//            .ignoresSafeArea(.container)
//            HStack(spacing: 0) {
//                Text(title)
//                    .foregroundStyle(.mainGreen)
//                Text("Y")
//                    .foregroundStyle(.mainViolet)
//            }
//            .font(.custom("Arial Black", size: 35))
//            .bold()
//            
//            HStack {
//                Spacer()
//                Button {
//                    //
//                } label: {
//                    Image(systemName: "gearshape.fill")
//                        .resizable()
//                        .foregroundStyle(.mainGreen)
//                        .frame(width: 25, height: 25)
//                }
//                .padding(.trailing)
//            }
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.top)
//    }
//}
//
//private struct ButtonMenu: View {
//    @Bindable var viewModel: WordViewModel
//    @Binding var navigationPath: NavigationPath
//    @Binding var testViewModel: TestViewModel?
//    
//    var body: some View {
//        let buttons: [ButtonMenuConfiguration] = [
//            ButtonMenuConfiguration(id: 1, title: "Все слова", isLocked: .unlock, destination: .allWords),
//            ButtonMenuConfiguration(id: 2, title: "Тест", isLocked: viewModel.conditionForLockMenu(), destination: .test)
//        ]
//        
//        VStack(spacing: 0) {
//            ForEach(buttons) { button in
//                ButtonMenuView(
//                    viewModel: viewModel,
//                    navigationPath: $navigationPath,
//                    testViewModel: $testViewModel,
//                    button: button
//                )
//                    .padding(.vertical, 15)
//            }
//        }
//    }
//}
//
//private struct ButtonMenuView: View {
//    @Bindable var viewModel: WordViewModel
//    @Binding var navigationPath: NavigationPath
//    @State private var showMessage = false
//    @Binding var testViewModel: TestViewModel?
//            
//    let button: ButtonMenuConfiguration
//    var isLock: Bool {
//        button.isLocked == .lock
//    }
//    
//    var body: some View {
//        HStack(alignment: .center, spacing: 0) {
//            ZStack {
//                Button {
//                    if button.destination == .test {
//                        testViewModel = TestViewModel(words: viewModel.words)
//                    } else {
//                        navigationPath.append(button.destination)
//                    }
//                } label: {
//                    HStack {
//                        Text(button.title)
//                    }
//                    .opacity(isLock ? 0.5 : 1)
//                    .frame(maxWidth: .infinity, maxHeight: 40)
//                }
//                .disabled(isLock)
//                
//                if isLock {
//                    Image(systemName: "lock.circle")
//                        .resizable()
//                        .frame(width: 30, height: 30)
//                }
//            }
//            .simultaneousGesture(TapGesture().onEnded {
//                if isLock {
//                    showMessage = true
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                        withAnimation {
//                            showMessage = false
//                        }
//                    }
//                }
//            })
//            
//        }
//        .foregroundStyle(.white)
//        .font(.custom("Arial Black", size: 24))
//        .padding(.vertical, 15)
//        .background(.mainViolet)
//        .clipShape(.rect(cornerRadius: 15))
//        .shadow(color: .gray, radius: 5, x: 5, y: 5)
//        .padding(.horizontal)
//        .overlay {
//            if showMessage {
//                ShowMessageTextView(showMessage: showMessage)
//            }
//        }
//
//    }
//}
//
//
