//
//  AudioRecorderHelper.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 3/3/21.
//

import Foundation

func getDateCreated(for file: URL) -> Date {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any], let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
        return creationDate
    } else {
        return Date()
    }
}
