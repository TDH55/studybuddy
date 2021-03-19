//
//  CSE439_ProjectApp.swift
//  CSE439_Project
//
//  Created by Taylor Howard on 2/6/21.
//

import SwiftUI

@main
struct CSE439_ProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
