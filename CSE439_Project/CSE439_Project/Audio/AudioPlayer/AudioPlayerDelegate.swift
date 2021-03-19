//
//  AudioPlayerDelegate.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 3/4/21.
//

import Foundation
import AVFoundation

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
}
