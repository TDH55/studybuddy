//
//  DateExtension.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 3/3/21.
//

import Foundation

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
