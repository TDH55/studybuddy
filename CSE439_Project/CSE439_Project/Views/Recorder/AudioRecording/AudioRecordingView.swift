//
//  AudioRecordingView.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 3/3/21.
//

import SwiftUI

struct AudioRecordingView: View {
    
//    var audioURL: URL
    @ObservedObject var audioRecording: AudioRecording
    
    @ObservedObject var audioPlayer: AudioPlayer
    
    var body: some View {
        VStack {
            //TODO: transcribe text -> save transcriptiona with url in core data?
            if audioRecording.isTranscribing {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .accessibility(label: Text("Audio recording is still transcribing"))
            } else{
                Text("\(audioRecording.transcription ?? "")")
                    .accessibility(label: Text("Audio recording transcription"))
            }
            
            Spacer()
            Button {
                if !audioPlayer.isPlaying {
                    guard let audioURL = audioRecording.url else { return }
                    audioPlayer.startPlaying(audioURL: audioURL)
                } else {
                    audioPlayer.stopPlaying()
                }
            } label: {
                Image(systemName: audioPlayer.isPlaying ? "pause.circle" : "play.circle")
                    .font(.system(size: 64))
            }
            .accessibility(label: Text("Toggle playing back audio recording"))
            .padding()
        }
        .navigationTitle("\(audioRecording.title ?? "Null Title")")
    }
}

//struct AudioRecordingView_Previews: PreviewProvider {
//    static var previews: some View {
//        AudioRecordingView(audioURL: URL(string: "https://google.com")!, audioPlayer: AudioPlayer())
//    }
//}
