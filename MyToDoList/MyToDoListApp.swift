//
//  MyToDoListApp.swift
//  MyToDoList
//
//  Created by marco rodriguez on 02/08/22.
//

import SwiftUI

@main
struct MyToDoListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
