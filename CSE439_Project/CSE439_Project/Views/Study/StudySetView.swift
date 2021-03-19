//
//  StudySetView.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 2/10/21.
//


import SwiftUI
import CoreData

struct StudySetView: View {
        
    @Environment(\.managedObjectContext) private var viewContext

//    let setID: NSManagedObjectID
//    let set: StudySet
    let terms: NSSet
    @ObservedObject var studySet: StudySet
    @State var termArray: [StudyTerm] = []
    
    @State var showingEditSheet = false
        
//    init(set: StudySet, terms: NSSet){
//        self.set = set
//        self.terms = terms
//        //TODO: Sort array by date
//    }
    
    init(setID objectID: NSManagedObjectID, in viewContext: NSManagedObjectContext) {
        if let studySet = try? viewContext.existingObject(with: objectID) as? StudySet {
            self.studySet = studySet
            self.terms = studySet.term ?? NSSet()
        } else {
            self.studySet = StudySet(context: viewContext)
            self.terms = NSSet()
            try? viewContext.save()
        }
    }
    func removeStudyCard(at index: Int) {
        termArray.remove(at: index)
    }
    
    var body: some View {
        ZStack{
            Button {
                self.termArray = (terms.allObjects as! [StudyTerm]).sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
            } label: {
                Text("Redo")
            }
            .accessibility(label: Text("Redo study set"))
            ForEach(0..<termArray.count, id: \.self) { index in
                FlippableCardView(term: termArray[index]) {
                    withAnimation{
                        self.removeStudyCard(at: index)
                    }
                }
            }
            
        }
        .onChange(of: studySet.term, perform: { value in
            print(self.termArray.count)
//            self.terms = studySet.term ?? NSSet()
            self.termArray = (terms.allObjects as! [StudyTerm]).sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
            print(self.termArray.count)
        })
        .onAppear{
//            self.terms = studySet.term ?? NSSet()
            self.termArray = (terms.allObjects as! [StudyTerm]).sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
        }
        .navigationTitle(studySet.title ?? "")
        //TODO: Add an edit set button and corresponding sheet view
        .toolbar(content: {
            Button {
                //toggle showing edit page
                self.showingEditSheet = true
            } label: {
                Text("Edit")
            }
        })
        .sheet(isPresented: $showingEditSheet, content: {
//            Text("edit")
//            EditStudySetSheetView(studySet: set, terms: terms)
            EditStudySetSheetView(setID: studySet.objectID, in: viewContext, termArray: $termArray)
        })
        
    }
}

//struct StudySetView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        StudySetView(set: StudySet(), terms: []).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
