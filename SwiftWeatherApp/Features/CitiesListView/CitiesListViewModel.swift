//
//  CitiesListViewModel.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 18/1/25.
//

import Foundation
import Observation

@Observable
class CitiesListViewModel {
    var cities: [City] = []
    var filteredCities: [City] = []

    init() {
        loadCities()
    }

    func loadCities() {
        let forecast: Forecast = loadJSON(filename: "forecast_scheme")
        cities = forecast.cities
    }

    func filterCities(for query: String) {
        if query.isEmpty {
            filteredCities = []
        } else {
            filteredCities = cities.filter { city in
                city.city.lowercased().contains(query.lowercased())
            }
        }
    }
}
