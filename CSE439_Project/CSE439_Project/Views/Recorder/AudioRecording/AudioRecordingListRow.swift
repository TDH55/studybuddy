//
//  AudioRecordingListRow.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 3/3/21.
//

import SwiftUI

struct AudioRecordingListRow: View {
    
//    var audioURL: URL
    let audioRecording: AudioRecording
    
    @StateObject var audioPlayer = AudioPlayer()
    
    var body: some View {
        NavigationLink(
            destination: AudioRecordingView(audioRecording: audioRecording, audioPlayer: audioPlayer),
            label: {
                HStack {
                    Text("\(audioRecording.title ?? "null title")")
                }
            })
    }
}
//
//struct AudioRecordingListRow_Previews: PreviewProvider {
//    static var previews: some View {
//        AudioRecordingListRow()
//    }
//}
