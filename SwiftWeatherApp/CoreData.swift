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
                    description.shouldInferMappingModelAutomatically = true
                }
    }
}


extension CoreDataStack {
    func save() {
        guard container.viewContext.hasChanges else { return }
        
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save the context:", error.localizedDescription)
        }
    }
    
    func add(_ city: City) async {
     
        
        container.viewContext.insert(city)
        
        save()
    }
    
    func delete(item: City) {
        container.viewContext.delete(item)
        save()
    }
    
    func requestById(_ id: UUID) -> NSFetchRequest<City>  {
        let request = City.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)
        return request
    }
    func saveSearch(query: String) {
        let context = container.viewContext
        let item = SearchHistoryItem(context: context)
        item.id = UUID()
        item.query = query
        item.searchedAt = Date()
        save()
    }
    func fetchSearchHistory(limit: Int = 10) -> [SearchHistoryItem] {
        let context = container.viewContext
        let req: NSFetchRequest<SearchHistoryItem> = SearchHistoryItem.fetchRequest()
        req.sortDescriptors = [
            NSSortDescriptor(keyPath: \SearchHistoryItem.searchedAt, ascending: false)
        ]
        req.fetchLimit = limit
        do {
            return try context.fetch(req)
        } catch {
            print("❌ Error cargando historial de búsquedas: \(error)")
            return []
        }
    }
       
    func deleteHistoryItem(_ item: SearchHistoryItem) {
        container.viewContext.delete(item)
        save()
    }
    
    func ensureUserSettings() {
        let context = container.viewContext
        let request: NSFetchRequest<UserSettings> = UserSettings.fetchRequest()
        if (try? context.count(for: request)) == 0 {
            let settings = UserSettings(context: context)
            settings.temperatureUnit = "C"
            settings.windSpeedUnit = "km/h"
            settings.isDarkMode = false
            save()
        }
    }

    func fetchUserSettings() -> UserSettings {
        let context = container.viewContext
        let request: NSFetchRequest<UserSettings> = UserSettings.fetchRequest()
        guard let settings = (try? context.fetch(request))?.first else {
            fatalError("UserSettings no disponible en Core Data")
        }
        return settings
    }
}
