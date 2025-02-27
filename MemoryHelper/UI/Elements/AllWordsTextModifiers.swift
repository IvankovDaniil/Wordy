//
//  AllWordsTextModifiers.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 27.02.2025.
//

import Foundation
import SwiftUI

struct AllWordsViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Arial", size: 22))
            .lineLimit(1)
            .layoutPriority(1)
            .fixedSize(horizontal: true, vertical: true)
            .padding()
            .background(Color.gray.opacity(0.2))
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke()
            }
    }
}

extension View {
    
    func customWordView() -> some View {
        modifier(AllWordsViewModifier())
    }
}
