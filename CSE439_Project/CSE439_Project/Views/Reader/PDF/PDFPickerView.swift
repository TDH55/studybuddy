//
//  PDFPickerView.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 3/17/21.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import PDFKit

struct PDFPickerView: UIViewControllerRepresentable {
    @Binding var fileText: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(fileText: $fileText)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller: UIDocumentPickerViewController
        
        controller = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf], asCopy: true)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    typealias UIViewControllerType = UIDocumentPickerViewController
    
    class Coordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
        @Binding var fileText: String
        
        init(fileText: Binding<String>) {
            self._fileText = fileText
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            print("Document is picked")
            //code to get text from document
            guard let pdfURL = urls.first else { return }
            if let pdf = PDFDocument(url: pdfURL) {
                fileText = ""
                let pageCount = pdf.pageCount
                let documentContent = NSMutableAttributedString()
                
                for i in 0..<pageCount {
                    guard let page = pdf.page(at: i) else { continue }
                    guard let pageContent = page.attributedString else { continue }
                    documentContent.append(pageContent)
                }
                fileText = documentContent.string
            }
        }
    }
    
}
