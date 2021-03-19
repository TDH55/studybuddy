//
//  CameraScannerView.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 2/24/21.
//

//Derived from https://medium.com/swlh/on-device-text-recognition-on-ios-with-swiftui-dd499b9eec0b

import SwiftUI
import Vision
import VisionKit

struct CameraScannerView: UIViewControllerRepresentable {
    //environment variable for sheet presentation mode
    @Environment(\.presentationMode) var presentationMode
    @Binding var scannedText: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scannedText: $scannedText, parent: self)
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        //do nothing
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var scannedText: Binding<String>
        var parent: CameraScannerView
        
        init(scannedText: Binding<String>, parent: CameraScannerView) {
            self.scannedText = scannedText
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            //process the scan
            let extractedImages = extractImages(from: scan)
            DispatchQueue.global(qos: .userInitiated).async {
                let processedText = self.recognizeText(from: extractedImages)
                DispatchQueue.main.async {
                    self.scannedText.wrappedValue = processedText //TODO: change this to += to allow users to append new scans to previous scans
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        
        //function to convert scans into an array of CGImage
        fileprivate func extractImages(from scan: VNDocumentCameraScan) -> [CGImage] {
            var extractedImages: [CGImage] = [CGImage]()
            
            for index in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: index)
                guard let cgImage = image.cgImage else { continue }
                
                extractedImages.append(cgImage)
            }
            
            return extractedImages
        }
        
        //function that gets text from a scan
        fileprivate func recognizeText(from images: [CGImage]) -> String {
            var recognizedText = ""
            let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
                guard error == nil else {
                    print("error: \(error!.localizedDescription)")
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                
                let maximumRecognitionCandidates = 1
                
                //append the top text recognition candidate to the recognized text string
                for observation in observations {
                    guard let candidate = observation.topCandidates(maximumRecognitionCandidates).first else { continue }
                    
                    recognizedText += "\(candidate.string)"
                }
            }
            
            recognizeTextRequest.recognitionLevel = .accurate
            
            //run the text recognition request on each image
            for image in images {
                let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
                
                try? requestHandler.perform([recognizeTextRequest])
            }
            
            return recognizedText
        }
    }
}
