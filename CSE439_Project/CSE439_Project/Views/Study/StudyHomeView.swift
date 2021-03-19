//
//  StudyHomeView.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 2/9/21.
//

import SwiftUI

struct StudyHomeView: View {
    //core data info
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: StudySet.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \StudySet.date, ascending: true)])
    
    private var studySets: FetchedResults<StudySet>
    
    //Sheet variable
    @State private var showingAddSet = false
    
    var body: some View {
        NavigationView{
            List{
                
                ForEach(studySets){ set in
                        NavigationLink(
                            //TODO: change to id
//                            destination: StudySetView(set: set, terms: set.term ?? []),
                            destination: StudySetView(setID: set.objectID, in: viewContext),
                            label: {
                                Text("\(set.title ?? "")")
                            })
                }
                .onDelete(perform: deleteStudySet)
            }
            .navigationTitle("Study")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button {
                        showingAddSet.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .accessibility(label: Text("Add new study set"))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .accessibility(label: Text("Edit study set list"))
                }
            }
        }
        .sheet(isPresented: $showingAddSet, content: {
            AddStudySetSheetView()
        })
    }
    
    func deleteStudySet(at offsets: IndexSet) {
        for index in offsets {
            let studySet = studySets[index]
            viewContext.delete(studySet)
        }
        
        //save the view context
        PersistenceController.shared.save()
    }
}

struct StudyHomeView_Previews: PreviewProvider {
    static var previews: some View {
        StudyHomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
