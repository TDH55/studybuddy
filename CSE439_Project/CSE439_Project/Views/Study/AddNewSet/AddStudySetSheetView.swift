//
//  AddStudySetSheetView.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 2/11/21.
//

import SwiftUI

struct AddStudySetSheetView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var title: String = ""
    
    //the next term to be added
    @State var currentTerm: String = ""
    @State var currentDefinition: String = ""
    
    //dictionary for the terms that have been added so far
    @State var termList: [StudyTerm] = []
    
    @State var newStudySet: StudySet?
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                //title input
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .accessibility(label: Text("New study set title input"))
                //term input
                VStack(alignment: .leading){
                    Group{
                        TextField("Term", text: $currentTerm)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding([.leading, .trailing, .top])
                            .accessibility(label: Text("New study term phrase input"))
                        TextField("Definition", text: $currentDefinition)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding([.leading, .trailing])
                            .accessibility(label: Text("New study term definition input"))
                        HStack{
                            Spacer()
                            Button {
                                guard let studySet = newStudySet else { return }
                                let newTerm: StudyTerm = StudyTerm(context: viewContext)
                                newTerm.phrase = currentTerm
                                newTerm.definition = currentDefinition
                                newTerm.isLearned = false
                                newTerm.set = newStudySet
                                newTerm.date = Date()
                                newTerm.id = UUID()
                                studySet.addToTerm(newTerm)
                                currentTerm = ""
                                currentDefinition = ""
                                termList.append(newTerm)
                            } label: {
                                Text("Add Term")
                            }
                            .accessibility(label: Text("Add new term to study set"))
                            .disabled(currentTerm.isEmpty || currentDefinition.isEmpty)
                            .padding()
                            Spacer()
                        }
                    }
                    .accessibility(label: Text("New term input"))
                }
                
                List {
                    Section(header:
                        EditButton()
                            .accessibility(label: Text("Edit term list"))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .overlay(Text("Terms"), alignment: .leading)
                    ){
                        ForEach(termList) { term in
                            VStack(alignment: .leading, spacing: 5){
                                Text("\(term.phrase!)")
                                    .font(.headline)
                                Text("\(term.definition!)")
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
            
                .navigationTitle("Add Study Set")
                .navigationBarTitleDisplayMode(.inline)
                //TODO: look into changing color of nav bar
                .toolbar(content: {
                    ToolbarItem(placement: .confirmationAction){
                        Button {
                            guard let studySet = newStudySet else { return }
                            studySet.title = title
                            PersistenceController.shared.save()
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Save")
                        }
                        .accessibility(label: Text("Save new study set"))
                        .disabled(title.isEmpty || termList.isEmpty)
                    }
                    
                    ToolbarItem(placement: .cancellationAction){
                        Button {
                            title = ""
                            currentTerm = ""
                            currentDefinition = ""
                            termList = []
                            guard let studySet = newStudySet else {
                                self.presentationMode.wrappedValue.dismiss()
                                return
                            }
                            viewContext.delete(studySet)
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                        .accessibility(label: Text("Cancel new study set"))
                    }
                })
        }
        .onAppear(perform: {
            newStudySet = StudySet(context: viewContext)
            guard let newStudySet = newStudySet else { return }
            newStudySet.id = UUID()
        })
    }
    
    func removeTerm(at offsets: IndexSet) {
        //get the index
        guard let index = offsets.first else { return }
        let termToRemove = termList[index]
        newStudySet?.removeFromTerm(termToRemove)
        viewContext.delete(termToRemove)
        termList.remove(atOffsets: offsets)
    }
}

struct AddStudySetSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddStudySetSheetView()
    }
}
