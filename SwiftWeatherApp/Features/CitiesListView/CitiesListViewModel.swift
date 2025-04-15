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

    func loadCities() {
        cities = fetchLocalCities(search: "")
    }
    
    func filterCities(for query: String) {
        let remoteCities = fetchRemoteCities(for: query)
        let existingCityNames = Set(cities.map { $0.city.lowercased() })
        filteredCities = remoteCities.filter { !existingCityNames.contains($0.city.lowercased()) }
    }
    
    func fetchRemoteCities(for query: String) -> [CityDto] {
        let forecast: WeatherApiResponse = loadJSON(filename: "five_cities_weather")
        return forecast.cities.filter {
            $0.timezone.lowercased().contains(query.lowercased())
        }.map {
            CityDto(from: $0, cityName: $0.timezone)
        }
    }

    
    func fetchLocalCities(search: String) -> [CityDto] {
        let request: NSFetchRequest<City> = City.fetchRequest()
        
        if !search.isEmpty {
            request.predicate = NSPredicate(format: "cityName CONTAINS[cd] %@", search)
        }
        
        do {
            return try _context.container.viewContext.fetch(request).map { CityDto(entity: $0) }
        } catch {
            fatalError("Error al obtener las ciudades locales: \(error.localizedDescription)")
        }
    }
        
    func delete(_ id: UUID) async {
        do {
            if let city = try _context.container.viewContext.fetch(requestById(id)).first {
                _context.container.viewContext.delete(city)
                try _context.container.viewContext.save()
            }
        } catch {
            print("Error al eliminar la ciudad con ID \(id): \(error.localizedDescription)")
        }
    }
    
    func deleteByIds(_ ids: [UUID]) async throws {
        for id in ids {
            if let city = try? _context.container.viewContext.fetch(requestById(id)).first {
                _context.container.viewContext.delete(city)
            }
        }
        guard _context.container.viewContext.hasChanges else { return }
        try _context.container.viewContext.save()
    }
    
    private func requestById(_ id: UUID) -> NSFetchRequest<City> {
        let request = City.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)
        return request
    }
}

