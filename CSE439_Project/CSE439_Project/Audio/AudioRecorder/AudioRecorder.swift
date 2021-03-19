//
//  AudioRecorder.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 3/3/21.
//

//Audio recorder derived from https://blckbirds.com/post/voice-recorder-app-in-swiftui-1/

import Foundation
import SwiftUI
import Combine
import AVFoundation
import CoreData

class AudioRecorder: NSObject, ObservableObject {
    
//    @Environment(\.managedObjectContext) private var viewContext

    override init() {
        super.init()
    }
    
    var viewContext: NSManagedObjectContext?

    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
    
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var currentURL: URL?
    
    var recordingTitle = ""
    
    //TODO: initialize an audio transcriber
    let audioTranscriber = AudioTranscriber()
        
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to start recording session")
        }
        
        //set location to save recording
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = filePath.appendingPathComponent("\(Date().toString(dateFormat: "MM-dd-YY_'at'_HH:mm:ss")).m4a")
        print(fileName)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder.record()
            currentURL = fileName
            recording = true
        } catch {
            print("Error starting recording")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        recording = false
        //TODO: Transcribe the recording
        //TODO: save the recording into a core data entry with name, url, and transcription
        if let audioURL = currentURL {
            guard let viewContext = self.viewContext else { return }
            let newRecording = AudioRecording(context: viewContext)
            newRecording.id = UUID()
            newRecording.url = audioURL
            //TODO: fix title
            if recordingTitle.isEmpty {
                newRecording.title = audioURL.lastPathComponent
            } else {
                newRecording.title = recordingTitle
            }
            newRecording.date = Date()
            newRecording.isTranscribing = true
            PersistenceController.shared.save()
            recordingTitle = ""
            audioTranscriber.transcribeAudio(url: audioURL) { transcription in
                newRecording.transcription = transcription
                //Save the core data context
                newRecording.isTranscribing = false
                PersistenceController.shared.save()
            }
        }
    }

    
    func deleteRecording(audioRecordingEntitiesToDelete: [AudioRecording]) {
        guard let viewContext = viewContext else { return }
        for recording in audioRecordingEntitiesToDelete {
            do {
                if let url = recording.url {
                    try FileManager.default.removeItem(at: url)
                }
            } catch {
                print("Error deleting file")
            }
            viewContext.delete(recording)
            PersistenceController.shared.save()
        }
    }
    
}
