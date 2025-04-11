//
//  TestFlow.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 03.03.2025.
//

import SwiftUI


struct TestFlow: View {
    @State var testViewModel: TestViewModel?
    let words: [Word]
    
    @State private var isPresenting = false
     
    init(words: [Word]) {
        self.words = words
    }
    
    
    var body: some View {
        VStack {
            StartsTestView(testViewModel: $testViewModel, words: words) {
                isPresenting = true
            }
            
            .fullScreenCover(isPresented: $isPresenting, content: {
                NavigationStack() {
                    TestView(testViewModel: $testViewModel)
                }
            })

            
        }
    }
}


