//
//  Persistence.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 2/6/21.
//

//Core data code referenced from https://www.hackingwithswift.com/

import CoreData

struct PersistenceController {
    //singleton for app to use
    static let shared = PersistenceController()

    //test configuration
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let newItem = Item(context: viewContext)
            let newSet = StudySet(context: viewContext)
            newSet.date = Date()
            newSet.title = "study set \(i)"
            newSet.id = UUID()
            for j in 0..<5 {
                let newTerm = StudyTerm(context: viewContext)
                newTerm.id = UUID()
                newTerm.date = Date()
                newTerm.isLearned = false
                newTerm.phrase = "Phrase \(j)"
                newTerm.definition = "How we are storing data in this app"
                newTerm.set = newSet
                newSet.addToTerm(newTerm)
            }

            newItem.timestamp = Date()
        }
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "CSE439_Project")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
}
