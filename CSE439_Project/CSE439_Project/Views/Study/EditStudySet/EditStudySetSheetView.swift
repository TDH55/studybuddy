//
//  EditStudySetSheetView.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 3/15/21.
//

import SwiftUI
import CoreData

struct EditStudySetSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var studySet: StudySet
    
    @Binding var termArray: [StudyTerm]
    
    @State var newTitle = ""
    @State var newTerms: [StudyTerm] = []
    
    @State var newTermPhrase = ""
    @State var newTermDefinition = ""
    
    init(setID objectID: NSManagedObjectID, in viewContext: NSManagedObjectContext, termArray: Binding<[StudyTerm]>) {
        if let studySet = try? viewContext.existingObject(with: objectID) as? StudySet {
            self.studySet = studySet
            self._termArray = termArray
        } else {
            self.studySet = StudySet(context: viewContext)
            self._termArray = termArray
            try? viewContext.save()
        }
    }
    
    var body: some View {
        NavigationView{
//            Text(newTitle)
            VStack(alignment: .leading) {
                //title input
                TextField("Title", text: $newTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .accessibility(label: Text("New title input"))
                //term input
                Group{
                    VStack(alignment: .leading){
                        TextField("Term", text: $newTermPhrase)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding([.leading, .trailing, .top])
                            .accessibility(label: Text("New term phrase input"))
                        TextField("Definition", text: $newTermDefinition)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding([.leading, .trailing])
                            .accessibility(label: Text("New term definition input"))
                        HStack{
                            Spacer()
                            Button {
                                let newTerm: StudyTerm = StudyTerm(context: viewContext)
                                newTerm.phrase = newTermPhrase
                                newTerm.definition = newTermDefinition
                                newTerm.isLearned = false
                                newTerm.set = studySet
                                newTerm.date = Date()
                                newTerm.id = UUID()
                                studySet.addToTerm(newTerm)
                                newTermPhrase = ""
                                newTermDefinition = ""
                                newTerms.append(newTerm)
                            } label: {
                                Text("Add Term")
                            }
                            .accessibility(label: Text("Add new term"))
                            .disabled(newTermPhrase.isEmpty || newTermDefinition.isEmpty)
                            .padding()
                            Spacer()
                        }
                    }
                }
                .accessibility(label: Text("New study terms inputs"))

                List {
                    Section(header:
                        EditButton()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .overlay(Text("Terms"), alignment: .leading)
                            .accessibility(label: Text("Edit term list"))
                    ){
                        ForEach(newTerms) { term in
                            VStack(alignment: .leading, spacing: 5){
                                Text("\(term.phrase ?? "")")
                                    .font(.headline)
                                Text("\(term.definition ?? "")")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .onDelete(perform: removeTerm)
                    }
                }
                .accessibility(label: Text("Term list"))
                .listStyle(GroupedListStyle())
            }
                .toolbar(content: {
                    ToolbarItem(placement: .cancellationAction){
                        Button{
                            //cancel
                            viewContext.rollback()
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                        .accessibility(label: Text("Cancel editing"))
                    }
                    
                    ToolbarItem(placement: .confirmationAction){
                        Button{
                            //done action
                            //TODO: update title
                            studySet.title = newTitle
                            PersistenceController.shared.save()
                            self.termArray = (studySet.term?.allObjects as? [StudyTerm] ?? []).sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Done")
                        }
                        .accessibility(label: Text("Save edits to study set"))
                    }
                })
        }
        .onAppear(perform: {
            self.newTitle = studySet.title ?? ""
            self.newTerms = (studySet.term?.allObjects as? [StudyTerm] ?? []).sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
        })
        
    }
    
    func removeTerm(at offsets: IndexSet) {
        //get the index
        guard let index = offsets.first else { return }
        let termToRemove = newTerms[index]
        //TODO: delete terms from view context when done is clicked
        studySet.removeFromTerm(termToRemove)
        viewContext.delete(termToRemove)
        
        newTerms.remove(atOffsets: offsets)
    }
}

//struct EditStudySetSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditStudySetSheetView()
//    }
//}
