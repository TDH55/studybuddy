//
//  AudioPlayer.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 3/4/21.
//

//AudioPlayer code derived from https://blckbirds.com/post/voice-recorder-app-in-swiftui-2/

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: NSObject, ObservableObject {
    
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    
    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var audioPlayer: AVAudioPlayer!
    
    func startPlaying(audioURL: URL) {
        let playbackSesssion = AVAudioSession.sharedInstance()
        
        //play the audio over the phones speaker
        do {
            try playbackSesssion.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch let error {
            print("Error playing audio over the devices speaker: \(error.localizedDescription)")
        }
        
        //start playing the audio
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
        } catch let error {
            print("Error playing the audio: \(error.localizedDescription)")
        }
    }
    
    func stopPlaying(){
        audioPlayer.stop()
        isPlaying = false
    }
    
}
