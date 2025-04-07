//
//  StartsTestView.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 01.04.2025.
//

import SwiftUI

struct StartsTestView: View {
    @Binding var testViewModel: TestViewModel?
    let words: [Word]
    var action: () -> Void
        
    @State var isShowMessage: Bool = false
    
    var body: some View {
        NavigationStack {
            
            VStack() {
                VStack {
                    Text("Тест состоит из:")
                    ForEach(TestType.allCases, id: \.self) { test in
                        Text("- \(test.rawValue)")
                    }
                }
                .font(.custom("Arial Black", size: 18))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(.mainGreen)
                .clipShape(.rect(cornerRadius: 16))
                
                ZStack {

                    Button {
                        testViewModel = TestViewModel(words: words)
                        action()
                    } label: {
                        Text("НАЧАТЬ ТЕСТ")
                            .wordTextModifier(color: .mainViolet)
                            .opacity(words.count < 5 ? 0.3 : 1.0)
                   }
                    .disabled(words.count < 5)
                    if words.count < 5 {
                        Image(systemName: "lock.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.black)
                    }
                }
                .onTapGesture {
                    if words.count < 5 {
                        print("My Log: ONTAPGEST ON StartsTestView has tapped")
                        isShowMessage = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isShowMessage = false
                        }
                    }
                }
                .overlay {
                    if isShowMessage {
                        ShowMessageTextView(showMessage: isShowMessage)
                    }
                }


            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image(.eyes)
                        .resizable()
                        .frame(width: 100, height: 100)
                }
            }
        }

        .padding(.horizontal)
    }
}

private struct ShowMessageTextView: View {
    let showMessage: Bool
    
    var body: some View {
        Text("У вас в словаре должно быть как минимум 5 слов для открытия теста")
            .font(.custom("Arial", size: 16))
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
