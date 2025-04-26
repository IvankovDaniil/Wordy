//
//  AudioPlayer.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 08.04.2025.
//

import AVFAudio


class AudioPlayer {
    var audioPlayer: AVAudioPlayer?
    var isEnable: Bool {
        if UserDefaults.standard.object(forKey: "isMusicEnable") == nil {
            true
        } else {
            UserDefaults.standard.bool(forKey: "isMusicEnable")
        }
    }
    
    func makeSound(name: String,withExtensions: String) {
        guard isEnable else {
            return
        }
        
        guard let sound = Bundle.main.url(forResource: name, withExtension: withExtensions) else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: sound)
            audioPlayer?.play()
        } catch {
        }
    }
    
}
