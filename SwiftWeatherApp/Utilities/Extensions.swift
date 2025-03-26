//
//  Extentions.swift
//  SwiftWeatherApp
//
//  Created by Johan Charles on 25/3/25.
//

extension CoreDataStack {
    // Add a convenience method to commit changes to the store.
    func save() {
        // Verify that the context has uncommitted changes.
        guard container.viewContext.hasChanges else { return }
        
        do {
            // Attempt to save changes.
            try container.viewContext.save()
        } catch {
            // Handle the error appropriately.
            print("Failed to save the context:", error.localizedDescription)
        }
    }
    
    func delete(item: Weather) {
        container.viewContext.delete(item)
        save()
    }
}
