//
//  InputCardView.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 2/9/21.
//

import SwiftUI

struct InputCardView: View {
    let inputMethod: InputMethod
    
    
    var body: some View {
        NavigationLink(
            destination: InputLink(method: inputMethod),
            label: {
                VStack(spacing: 10) {
                    Text(inputMethod.rawValue)
                    switch inputMethod {
                    case .Camera:
                        Image(systemName: "doc.text.viewfinder")
                    case .PDF:
                        Image(systemName: "doc.text.fill")
                    }
                }
                .padding([.top, .bottom])
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(Color.accentColor)
                .cornerRadius(15)
            })
            .foregroundColor(.black)
        
    }
}

struct InputCardView_Previews: PreviewProvider {
    static var previews: some View {
        InputCardView(inputMethod: .PDF)
    }
}
