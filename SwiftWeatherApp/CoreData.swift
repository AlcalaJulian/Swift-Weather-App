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


extension CoreDataStack {
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
    
    func add(_ city: City) async {
       
        
//        let newCity = City(context: container.viewContext)
//        newCity.id = UUID()
//        newCity.cityName = city.city
//        
//        newCity.citylocation?.latitude = city.location.latitude
//        newCity.citylocation?.longitude = city.location.longitude
//        
//        city.weather.forEach{
//            let weather = Weather(context: container.viewContext)
//            weather.day = $0.day
//            
//            $0.hourly.forEach { HourlyDto in
//                let hourly = HourlyWeather(context: container.viewContext)
//                hourly.condition = HourlyDto.condition
//                hourly.hourly = HourlyDto.hour
//                hourly.humidity = Int32(HourlyDto.humidity)
//                hourly.temperature = Int32(HourlyDto.temperature)
//                hourly.windSpeed = Int32(HourlyDto.windSpeed)
//                
//                weather.addToWeatherhourly(hourly)
//            }
//            
//            newCity.addToCityweather(weather)
//        }
     
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
}
