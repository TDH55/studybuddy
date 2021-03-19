//
//  AudioRecordingsList.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 3/3/21.
//

import SwiftUI

struct AudioRecordingsList: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: AudioRecording.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AudioRecording.date, ascending: false)])
    
    private var recordings: FetchedResults<AudioRecording>
    
    var body: some View {
        List{
            ForEach(recordings, id: \.id) { recording in
                AudioRecordingListRow(audioRecording: recording)
            }
            .onDelete(perform: delete)
        }
        .accessibility(label: Text("List of audio recordings"))
        .listStyle(PlainListStyle())
    }
    
    func delete(at offsets: IndexSet) {
        var audioRecordingEntitiesToDelete = [AudioRecording]()
        for index in offsets {
            let recording = recordings[index]
            audioRecordingEntitiesToDelete.append(recording)
        }
        audioRecorder.deleteRecording(audioRecordingEntitiesToDelete: audioRecordingEntitiesToDelete)
    }
}

struct AudioRecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecordingsList(audioRecorder: AudioRecorder())
    }
}
