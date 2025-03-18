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
            Text("Поздравляю, ты прошел все задания 🎉")
                .font(.custom("Arial", size: 23))
                .bold()
                .foregroundColor(.green)
                .transition(.opacity)
            Button {
                dismiss()
                testViewModel = nil
            } label: {
                Text("Обратно в меню")
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
