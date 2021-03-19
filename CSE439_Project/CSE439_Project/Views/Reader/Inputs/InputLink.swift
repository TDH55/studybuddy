//
//  InputLink.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 2/9/21.
//

//TODO: clean up this view
import SwiftUI

enum DisplayedSheet: Identifiable {
    case LinkStudySet, Camera, PDFInput
    var id: Int {
        hashValue
    }
}

struct InputLink: View {
    let method: InputMethod
    
    let title: String
    init(method: InputMethod) {
        self.method = method
        
        switch method {
        case .PDF:
            self.title = "PDF"
        case .Camera:
            self.title = "Camera"
        }
        
    }
    
    @State var speedReaderText: String = ""
    
    @State var currentWordIndex: Int = 0
    
    @State var playingText: Bool = false
    
    @State var wordsPerMinute: Float = 500
    
    @State var speedReaderTextArray: [String] = []
    
    @State var timer = Timer.publish(every: Double(60 / 500), on: .main, in: .common).autoconnect()
    
    @State var linkedStudySets: [StudySet] = []
    @State var linkedTerms: [String] = []
    
    //state vars for showing the different inputs
    @State private var showingSheet = false
//    @State private var showingLinkStudySetSheet = false
    @State private var displayedSheet: DisplayedSheet?
    
    
    func calculateWPM(wpm: Float) -> Double {
        return Double(60 / wpm.rounded(.down))
    }
    
    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
    
    func startTimer() {
//        let interval = Double(60 / wordsPerMinute.rounded(.down))
        let interval = calculateWPM(wpm: wordsPerMinute)
        timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
    }
    
    func convertStringToArray(text: String) -> [String] {
        text.components(separatedBy: " ")
    }
    
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            Text("\(wordsPerMinute.rounded(.down).clean) WPM")
            //TODO: update range
            Slider(value: $wordsPerMinute, in: 0...1000)
                .padding()
                .accessibility(label: Text("Words per minute slider"))
            Spacer()
            if speedReaderTextArray.isEmpty {
                Text("Start Scanning")
                    .font(.system(size: 24))
            } else {
                if currentWordIndex >= speedReaderTextArray.count {
                    Button {
                        currentWordIndex = 0
                    } label: {
                        Text("Redo")
                    }
                    .accessibility(label: Text("Redo last text"))
                }
                else {
                    if linkedTerms.contains(speedReaderTextArray[currentWordIndex]) {
                        Text(speedReaderTextArray[currentWordIndex])
                            .font(.system(size: 24))
                            .padding()
                            .background(Color.yellow)
                            .cornerRadius(15)
                    } else {
                        Text(speedReaderTextArray[currentWordIndex])
                            .font(.system(size: 24))
                    }
                }
            }
            
            Spacer()
            //play/pause button
            Button {
                playingText.toggle()
            } label: {
                Image(systemName: playingText ? "pause.fill" : "play.fill")
                    .font(.system(size: 24))
            }
                .accessibility(label: Text("Toggling playing speed reader text"))
                .disabled(speedReaderTextArray.isEmpty)
                .padding()
            Spacer()
            HStack {
                Button {
                    //show term sheet
                    self.showingSheet = true
                    self.displayedSheet = .LinkStudySet

                } label: {
                    Text("Link Study Sets")
                }
                .accessibility(label: Text("Link study sheet to speed reader"))
                Spacer()
                switch method {
                case InputMethod.PDF:
                    Button {
                        //pdf input
                        self.showingSheet = true
                        self.displayedSheet = .PDFInput
                    } label: {
                        Text("Select PDF")
                    }
                        .accessibility(label: Text("Select pdf to speed read"))
                        .padding()
                case InputMethod.Camera:
                    Button {
                        // present camera input
                        self.showingSheet = true
                        self.displayedSheet = .Camera
//                        print(self.showingCameraScannerInput)
                        print("show camera")
                    } label: {
                        Text("Scan")
                    }
                        .accessibility(label: Text("scan text to speed read"))
                        .padding()
                }
            }
            .padding()
        }
        .onAppear() {
            self.stopTimer()
        }
        .onChange(of: linkedStudySets, perform: { value in
            self.linkedTerms = []
            for set in linkedStudySets {
                guard let terms = set.term else { return }
                for term in terms {
                    if let term = (term as? StudyTerm)?.phrase {
                        linkedTerms.append(term)
                    }
                }
            }
        })
        .onChange(of: playingText, perform: { _ in
            //TODO: pause the timer
            if playingText {
                self.startTimer()
            } else {
                self.stopTimer()
            }
        })
        .onChange(of: speedReaderText, perform: { _ in
            //convert string to array of strings
            speedReaderTextArray = convertStringToArray(text: speedReaderText)
            speedReaderTextArray.removeAll(where: {$0.isEmpty})
        })
        .onChange(of: wordsPerMinute, perform: { _ in
            if playingText {
                self.startTimer()
            }
        })
        
        .sheet(item: $displayedSheet) { item in
            switch item {
            case .Camera:
                CameraScannerView(scannedText: $speedReaderText)
            case .LinkStudySet:
                AddStudySetLinkView(selectedStudySets: $linkedStudySets)
            case .PDFInput:
                PDFPickerView(fileText: $speedReaderText)
            }
        }
        
        .onReceive(timer) { _ in
            currentWordIndex += 1
            if currentWordIndex >= speedReaderTextArray.count {
                playingText = false
                stopTimer()
            }
        }
        .navigationBarTitle(title)
        
        .navigationBarTitleDisplayMode(.inline)
//        .toolbar(content: {
//            ToolbarItem(placement: .navigationBarTrailing, content: {
//                Button {
//                    speedReaderText = ""
//                    speedReaderTextArray = []
//                    playingText = false
//                } label: {
//                    Text("Clear")
//                }
//            })
//        })
    }
}

struct InputLink_Previews: PreviewProvider {
    static var previews: some View {
        InputLink(method: .Camera)
    }
}
