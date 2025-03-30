//
//  AllWordsTextModifiers.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 27.02.2025.
//

import Foundation
import SwiftUI

struct AllWordsViewModifier: ViewModifier {
    var screenWidth: CGFloat
    let color: Color

    func body(content: Content) -> some View {
        let dynamicFontSize = max(16, screenWidth * 0.05)
        let dynamicPadding = max(8, screenWidth * 0.03)
        
        return content
            .font(.custom("Arial", size: dynamicFontSize))
            .foregroundStyle(.white)
            .lineLimit(1)
            .layoutPriority(1)
            .fixedSize(horizontal: true, vertical: true)
            .padding(dynamicPadding)
            .background(color)
            .clipShape(Capsule())
    }
}

extension View {
    
    func customWordView(screenWidth: CGFloat, color: Color = .mainViolet) -> some View {
        modifier(AllWordsViewModifier(screenWidth: screenWidth, color: color))
    }
}
