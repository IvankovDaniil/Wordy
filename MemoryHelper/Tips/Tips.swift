//
//  Tips.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 17.04.2025.
//

import Foundation
import TipKit

struct AddNewWordTip: Tip {
    var title: Text {
        Text("Добавить слово")
            .font(.custom("Arial Black", size: 18))
    }
    
    var message: Text? {
        Text("Нажми на эту кнопку, что бы добавить новое слово")
            .font(.custom("Arial", size: 16))
            .foregroundStyle(.black)
    }
    
    var image: Image? {
        Image(systemName: "hand.point.up.fill")
    }
}


struct DeleteWordsTip: Tip {
    var title: Text {
        Text("Удалить слово")
            .font(.custom("Arial Black", size: 18))
    }
    
    var message: Text? {
        Text("Нажми на эту кнопку, что бы удалить слово")
            .font(.custom("Arial", size: 16))
            .foregroundStyle(.black)
    }
    
    var image: Image? {
        Image(systemName: "trash")
    }
}
