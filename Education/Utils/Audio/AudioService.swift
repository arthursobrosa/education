//
//  AudioService.swift
//  Education
//
//  Created by Eduardo Dalencon on 30/07/24.
//

import AVFoundation
import Foundation

enum Sound: String, CaseIterable {
    case alarm
    
    var url: URL? {
        Bundle.main.url(forResource: rawValue, withExtension: "mp3")
    }
    
    var numberOfLoops: Int {
        0
    }
    
    var volume: Float {
        1.0
    }
    
    var rate: Float {
        1.0
    }
}

enum SoundError: Error {
    case URLNotFound
    case invalidURL
}

protocol AudioServiceProtocol: AnyObject {
    var allPlayers: [AVAudioPlayer] { get set }
    
    func setSounds()
    func getSound(_ soundCase: Sound) throws -> AVAudioPlayer
    func playSound(_ soundCase: Sound)
    func stopSound(_ soundCase: Sound)
}

class AudioService: AudioServiceProtocol {
    var allPlayers: [AVAudioPlayer] = []
    
    init() {
        setSounds()
    }
    
    func setSounds() {
        let allSoundCases = Sound.allCases
        
        for soundCase in allSoundCases {
            do {
                let audioPlayer = try getSound(soundCase)
                allPlayers.append(audioPlayer)
            } catch let error {
                print(error)
            }
        }
    }
    
    func getSound(_ soundCase: Sound) throws -> AVAudioPlayer {
        guard let soundURL = soundCase.url else {
            throw SoundError.URLNotFound
        }
        
        do {
            return try AVAudioPlayer(contentsOf: soundURL)
        } catch {
            throw SoundError.invalidURL
        }
    }
    
    func playSound(_ soundCase: Sound) {
        let audioPlayer = allPlayers.first(where: { $0.url == soundCase.url })
        audioPlayer?.numberOfLoops = soundCase.numberOfLoops
        audioPlayer?.volume = soundCase.volume
        audioPlayer?.enableRate = true
        audioPlayer?.rate = soundCase.rate
        audioPlayer?.play()
    }
    
    func stopSound(_ soundCase: Sound) {
        let audioPlayer = allPlayers.first(where: { $0.url == soundCase.url })
        audioPlayer?.stop()
    }
}
