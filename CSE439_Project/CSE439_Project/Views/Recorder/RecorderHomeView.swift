//
//  RecorderHomeView.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 2/9/21.
//

import SwiftUI

struct RecorderHomeView: View {
    
    //TODO: should this go throughout the whole app?
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var audioRecorder = AudioRecorder()
    
    @State var newRecordingTitle = ""
    
    @State var addNewRecording = false
    
    
    var body: some View {
        NavigationView{
            VStack{
                AudioRecordingsList(audioRecorder: audioRecorder)
                
                
                if addNewRecording {
                    //TODO: add animate in
                    Button {
                        if audioRecorder.recording {
                            hideKeyboard()
                            audioRecorder.recordingTitle = newRecordingTitle
                            newRecordingTitle = ""
                            audioRecorder.stopRecording()
                        }else {
                            hideKeyboard()
                            audioRecorder.startRecording()
                        }
                        print("toggled recording")
                    } label: {
                        //TODO: show waveform while recording
                        Image(systemName: audioRecorder.recording ? "stop.fill" : "circle.fill")
                            .font(.system(size: 64))
                    }
                    .accessibility(label: Text("Toggle recording audio"))
                    .disabled(newRecordingTitle.isEmpty)
                    
                    TextField("Recording Name", text: $newRecordingTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }

                

            }
            .onAppear(perform: {
                audioRecorder.viewContext = viewContext
            })
                .navigationTitle("Recorder")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading, content: {
                        Button {
                            addNewRecording.toggle()
                        } label: {
                            Image(systemName: addNewRecording ? "minus.circle" : "plus.circle")
                        }
                        .accessibility(label: Text("Add new audio recording"))
                        .disabled(audioRecorder.recording)
                    })
                    
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        EditButton()
                            .accessibility(label: Text("Edit audio recording list"))
                    })
                }
        }
        
    }
}

struct RecorderHomeView_Previews: PreviewProvider {
    static var previews: some View {
        RecorderHomeView()
    }
}
