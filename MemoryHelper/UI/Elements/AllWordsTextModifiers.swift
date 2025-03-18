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

    func body(content: Content) -> some View {
        let dynamicFontSize = max(16, screenWidth * 0.05)
        let dynamicPadding = max(8, screenWidth * 0.03)
        
        return content
            .font(.custom("Arial", size: dynamicFontSize))
            .lineLimit(1)
            .layoutPriority(1)
            .fixedSize(horizontal: true, vertical: true)
            .padding(dynamicPadding)
            .background(Color.gray.opacity(0.2))
            .clipShape(Capsule())
            .overlay {
                Capsule().stroke()
            }
    }
}

extension View {
    
    func customWordView(screenWidth: CGFloat) -> some View {
        modifier(AllWordsViewModifier(screenWidth: screenWidth))
    }
}
