//
//  CoreDataStorage.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 16/03/2021.
//

import CoreData

class CoreDataStorage {
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "GitSearchPersistentContainer")
        persistentContainer.loadPersistentStores { persistentContainer, error in
            if let error = error {
                fatalError("Core Data store failed to load with \(error)")
            }
        }
    }
}
