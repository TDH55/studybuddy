//
//  ContentView.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 2/6/21.
//

import SwiftUI
import CoreData


struct ContentView: View {
    var body: some View {
        TabView {
            ReaderHomeView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Reader")
                }
                
            RecorderHomeView()
                .tabItem {
                    Image(systemName: "record.circle")
                    Text("Recorder")
                }
                
            StudyHomeView()
                .tabItem {
                    Image(systemName: "note.text")
                    Text("Study")
                }
                
//            Text("More")
//                .tabItem {
//                    Image(systemName: "list.bullet")
//                    Text("More")
//                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
