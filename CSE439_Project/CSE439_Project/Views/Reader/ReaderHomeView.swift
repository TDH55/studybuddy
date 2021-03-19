//
//  ReaderHomeView.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 2/9/21.
//

import SwiftUI


struct ReaderHomeView: View {
    private var inputGridLayout = [GridItem(.adaptive(minimum: 180, maximum: .infinity)), GridItem(.adaptive(minimum: 180, maximum: .infinity))]
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVGrid(columns: inputGridLayout) {
                    ForEach(InputMethod.allCases, id: \.self) { method in
                        InputCardView(inputMethod: method)
                            .accessibility(label: Text(method.rawValue))
                    }
                }
                .padding()
            }
            .navigationTitle("Reader")
        }
    }
}

struct ReaderHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderHomeView()
    }
}
