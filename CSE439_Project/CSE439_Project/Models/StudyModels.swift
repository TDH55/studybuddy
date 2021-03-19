//
//  StudyModels.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 2/11/21.
//

import Foundation


struct StudyCard: Identifiable {
    let id = UUID()
    let term: String
    let definition: String
}

struct TermSet: Identifiable {
    let id = UUID()
    let title: String
    let terms: [StudyCard]
}
