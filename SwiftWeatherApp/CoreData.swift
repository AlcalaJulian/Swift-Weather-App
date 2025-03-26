//
//  CoreData.swift
//  SwiftWeatherApp
//
//  Created by Johan Charles on 25/3/25.
//

import Observation
import CoreData

@Observable
class CoreDataStack {
    static let shared = CoreDataStack()
    let container: NSPersistentContainer
    
    init(inMemory:Bool = false) {
        container = NSPersistentContainer(name: "SwiftWeatherModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        Migration()
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Fail to load persistence container \(error.localizedDescription)")
            }
        }
    }
    
    private func Migration(){
        container.viewContext.automaticallyMergesChangesFromParent = true
                if let description = container.persistentStoreDescriptions.first {
                    description.shouldMigrateStoreAutomatically = true
                    description.shouldInferMappingModelAutomatically = false
                }
    }
}
