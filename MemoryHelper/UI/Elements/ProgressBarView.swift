//
//  ProgressBarView.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 13.03.2025.
//

import SwiftUI

struct ProgressBarView: View {
    let totalValue: Double
    let currentValue: Double
    
    var body: some View {
        HStack {
            ProgressView(value: currentValue, total: totalValue)
                .tint(.mainViolet)
                .scaleEffect(x: 1, y: 3, anchor: .center)
            Text("\(Int(currentValue))/\(Int(totalValue))")
                .font(.custom("Arial", size: 20))
                .foregroundStyle(.mainGreen)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProgressBarView(totalValue: 20, currentValue: 1)
}
