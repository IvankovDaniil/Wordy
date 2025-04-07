//
//  LaunchScreenAnimation.swift
//  MemoryHelper
//
//  Created by Даниил Иваньков on 25.03.2025.
//

import SwiftUI
import AVKit
import AVFoundation

struct LaunchScreenAnimation: View {
    var body: some View {
        VStack {
            VideoBackgroundView(videoName: "animation", videoType: "mp4")
                .ignoresSafeArea()
        }
    }
}

class AudioPlayer {
    var audioPlayer: AVAudioPlayer?
    
    deinit {
        print("MY LOG: audioPlayer deinin")
    }
    
    func makeSound() {
        guard let sound = Bundle.main.url(forResource: "launchScreenSound", withExtension: "wav") else {
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

struct VideoBackgroundView: UIViewControllerRepresentable {
    let videoName: String
    let videoType: String
    var audioPlayer = AudioPlayer()
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        let player = AVPlayer(url: Bundle.main.url(forResource: videoName, withExtension: videoType)!)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect // Чтобы видео заполняло экран без черных полос
        
        // Настройки слоя чистого
        playerLayer.frame = UIScreen.main.bounds
        playerLayer.backgroundColor = UIColor.clear.cgColor
        
        // Добавляем слой на контроллер
        controller.view.layer.addSublayer(playerLayer)
        
        // Запускаем видео и звук
        player.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            audioPlayer.makeSound()
        }

        return controller
    }
    
    
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
