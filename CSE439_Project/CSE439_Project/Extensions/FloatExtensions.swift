//
//  FloatExtensions.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 3/4/21.
//

//Clean extension from https://stackoverflow.com/questions/31390466/swift-how-to-remove-a-decimal-from-a-float-if-the-decimal-is-equal-to-0/31390870

import Foundation

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
