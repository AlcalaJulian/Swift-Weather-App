//
//  CitiesListViewModel.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 18/1/25.
//

import Foundation
import Observation
import CoreData

@Observable
class CitiesListViewModel {
    var cities: [CityDto] = []
    var filteredCities: [CityDto] = []
    private let _context: CoreDataStack = CoreDataStack.shared
    var searchHistory: [SearchHistoryItem] = []
    
    func loadCities() {
        cities = fetchLocalCities(search: "")
    }
    
    func filterCities(for query: String) {
       
            filteredCities = []
            
            fetchRemoteCities(for: query).forEach { data in
                if (cities.isEmpty || cities.first(where: { city in
                    city.city == data.city
                }) == nil){
                    filteredCities.append(data)
                }
            }
    }

      func loadHistory() {
          searchHistory = _context.fetchSearchHistory()
      }
      
    func deleteHistoryItems(at offsets: IndexSet) {
        let items = offsets.map { searchHistory[$0] }
        items.forEach { _context.deleteHistoryItem($0) }
        loadHistory()
    }

    func fetchRemoteCities(for query: String) -> [CityDto] {
        let forecast: Forecast = loadJSON(filename: "forecast_scheme")
        return forecast.cities.filter{
            $0.city.lowercased().contains(query.lowercased())
        }.map {
            CityDto(from: $0)
        }
    }
    
    func fetchLocalCities(search: String) -> [CityDto] {
        let request: NSFetchRequest<City> = City.fetchRequest()
        
        if !search.isEmpty{
            request.predicate = NSPredicate(format: "cityName CONTAINS[cd] %@", search)
        }
        
        var cities :[CityDto] = []
        
        do{
            
            cities = try _context.container.viewContext.fetch(request).map {
                CityDto(from: $0)
            }
            
        }catch{
            fatalError("Error request cities \(error.localizedDescription)")
        }
        
        return cities;
    }
    
    
    func delete(_ id: UUID) async {
        
        do{
            let city = try _context.container.viewContext.fetch(requestById(id)).first
            
            if let city
            {
                _context.container.viewContext.delete(city)
                try _context.container.viewContext.save()
            }
        }catch{
            
        }
    }
    
    func deleteByIds(_ ids: [UUID]) async throws {
            
            ids.forEach { id in
                let city = try? _context.container.viewContext.fetch(requestById(id)).first
                
                if let city
                {
                    _context.container.viewContext.delete(city)
                }
            }
            
        guard _context.container.viewContext.hasChanges else { return }
            
        try _context.container.viewContext.save()
    }
    
    private func requestById(_ id: UUID) -> NSFetchRequest<City>  {
        let request = City.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)
        return request
    }    
    
}
