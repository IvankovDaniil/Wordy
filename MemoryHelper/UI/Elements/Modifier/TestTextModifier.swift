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
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Arial Black", size: 22))
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(color)
            .cornerRadius(12)
            .shadow(radius: 5)
    }
}


extension View {
    
    func ruleTextModifier() -> some View {
        modifier(RuleTextModifier())
    }
    
    func wordTextModifier(color: Color) -> some View {
        modifier(WordTextModifier(color: color))
    }
}
