//
//  AddStudySetLinkView.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 3/12/21.
//

import SwiftUI

struct AddStudySetLinkView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: StudySet.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \StudySet.date, ascending: true)])
    
    private var studySets: FetchedResults<StudySet>
    
    @Binding var selectedStudySets: [StudySet]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(studySets) { set in
                    LinkStudySetRow(studySet: set, isSelected: selectedStudySets.contains(set)) {
                        print("clicked")
                        if self.selectedStudySets.contains(set) {
                            self.selectedStudySets.removeAll(where: { $0 == set })
                        } else {
                            self.selectedStudySets.append(set)
                        }
                    }
                }
            }
            .accessibility(label: Text("List of study sets"))
                .toolbar(content: {
                    //TODO: add a cancel button
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            print("link set")
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Done")
                        }
                    }
                })
            .navigationTitle("Study Sets")
        }
    }
}

struct AddStudySetLinkView_Previews: PreviewProvider {
    static var previews: some View {
        AddStudySetLinkView(selectedStudySets: .constant([]))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
