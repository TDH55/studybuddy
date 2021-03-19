//
//  LinkStudySetRow.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 3/12/21.
//

import SwiftUI

struct LinkStudySetRow: View {
    let studySet: StudySet
    var isSelected: Bool
    
    var action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        } label: {
            HStack {
                Text("\(studySet.title ?? "")")
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

//struct LinkStudySetRow_Previews: PreviewProvider {
//    static var previews: some View {
//        LinkStudySetRow()
//    }
//}
