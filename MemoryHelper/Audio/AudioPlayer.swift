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
        print("MY LOG: isEnable =", isEnable)
        guard isEnable else {
            print("MY LOG: sound is disabled in settings")
            return
        }
        
        guard let sound = Bundle.main.url(forResource: name, withExtension: withExtensions) else {
            print("error with soudn launchScreen")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: sound)
            audioPlayer?.play()
        } catch {
            print("Erorr with playing sound")
        }
    }
    
}
