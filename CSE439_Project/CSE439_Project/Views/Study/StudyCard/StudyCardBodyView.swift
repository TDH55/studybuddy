//
//  StudyCardBodyView.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 2/18/21.
//

import SwiftUI

struct StudyCardBodyView: View {
    let content: String
    let color: Color
    
    var body: some View {
        ZStack {
            color
                .cornerRadius(25)
            Text(content)
        }
    }
}

struct StudyCardBodyView_Previews: PreviewProvider {
    static var previews: some View {
        StudyCardBodyView(content: "This is a study card", color: .blue)
    }
}
