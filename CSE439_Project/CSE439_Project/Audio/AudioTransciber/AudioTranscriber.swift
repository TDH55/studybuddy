//
//  AudioTranscriber.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 3/4/21.
//

//transcription code derived from https://www.hackingwithswift.com/example-code/libraries/how-to-convert-speech-to-text-using-sfspeechrecognizer

//TODO: clean up handling of optionals
import Foundation
import Speech

class AudioTranscriber {
    let recognizer = SFSpeechRecognizer()
    
    func transcribeAudio(url: URL, completion: @escaping (String) -> ()) {
        var recognizedString = ""
        let request = SFSpeechURLRecognitionRequest(url: url)

        recognizer?.recognitionTask(with: request) {(result, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(recognizedString)
            } else {
                if result?.isFinal ?? false {
                    recognizedString = result?.bestTranscription.formattedString ?? ""
                    completion(recognizedString)
                }
            }
        }
    }
}

