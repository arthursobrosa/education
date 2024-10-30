//
//  AudioService.swift
//  AudioService
//
//  Created by Eduardo Dalencon on 30/07/24.
//

import AVFoundation
import Foundation

var audioPlayer: AVAudioPlayer?

class AudioService {
    private var timer: Timer?

    init() {}

    func playAudio(from url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()

        } catch {
            print("Erro ao tocar áudio: \(error.localizedDescription)")
        }
    }

    func stopAudio() {
        audioPlayer?.stop()
    }

    func pauseAudio() {
        audioPlayer?.pause()
    }

    func resumeAudio() {
        audioPlayer?.play()
    }

    func setVolume(to volume: Float) {
        audioPlayer?.volume = volume
    }
}
