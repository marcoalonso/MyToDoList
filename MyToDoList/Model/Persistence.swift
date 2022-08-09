//
//  Persistence.swift
//  MyToDoList
//
//  Created by marco rodriguez on 02/08/22.
//

import CoreData

struct PersistenceController {
    // MARK: - 1.- Persistent Controller
    
    static let shared = PersistenceController()

    // MARK: - 2. Container

    let container: NSPersistentContainer

    // MARK: - 3. Initialization
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MyToDoList")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - 4. Preview
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<5 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = "Tarea Num: \(i)"
            newItem.completion = false
            newItem.id = UUID()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
