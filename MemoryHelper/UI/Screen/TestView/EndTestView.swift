//
//  EndTestView.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 12.03.2025.
//

import SwiftUI


struct EndTestView: View {
    @Binding var testViewModel: TestViewModel?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Тест пройден")
                .font(.custom("Arial Black", size: 24))
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.mainGreen)
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding()
                .multilineTextAlignment(.center)
            Button {
                dismiss()
                testViewModel = nil
            } label: {
                Text("Обратно в меню")
                    .padding()
                    .font(.custom("Arial Black", size: 24))
                    .background(Color.mainViolet)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .padding(.horizontal)
    }
}

