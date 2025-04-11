//
//  Haptic.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 09.04.2025.
//
import UIKit


enum Haptic {
    static var isEnable: Bool {
        if UserDefaults.standard.object(forKey: "isHapticsEnable") == nil {
            true
        } else {
            UserDefaults.standard.bool(forKey: "isHapticsEnable")
        }
    }
    
    static func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isEnable else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
