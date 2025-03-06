//
//  NextTestButtonView.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 06.03.2025.
//
import SwiftUI

struct NextTestButtonView: View {
    let testViewModel: TestViewModel
    
    init(testViewModel: TestViewModel) {
        self.testViewModel = testViewModel
    }
    
    var body: some View {
        VStack() {
            Text("Правильно! 🎉")
                .font(.custom("Arial", size: 20))
                .foregroundColor(.green)
                .transition(.opacity)
            
            Button("Следующий") {
                withAnimation {
                    testViewModel.isRightWord = false
                    testViewModel.nextTest()
                }
            }
            .font(.custom("Arial", size: 18))
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}
