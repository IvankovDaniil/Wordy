//
//  TestTextModifier.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 14.03.2025.
//

import Foundation
import SwiftUI


struct RuleTextModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Arial", size: 19))
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
}

struct WordTextModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Arial", size: 24))
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(12)
            .shadow(radius: 5)
    }
}


extension View {
    
    func ruleTextModifier() -> some View {
        modifier(RuleTextModifier())
    }
    
    func wordTextModifier() -> some View {
        modifier(WordTextModifier())
    }
}
