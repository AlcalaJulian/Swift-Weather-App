//
//  model.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 14/1/25.
//

import Foundation
import SwiftUICore
import MapKit

struct Forecast: Codable {
    let cities: [CityApi]
}

struct CityApi: Codable, Hashable {
    let city: String
    let location: LocationApi
    let weather: [WeatherApi]
    
    func getCLLocation() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
}

struct LocationApi: Codable, Hashable {
    let latitude: Double
    let longitude: Double
}

struct WeatherApi: Codable, Hashable, Identifiable {
    var id: String { day }
    let day: String
    let hourly: [HourlyWeatherApi]
}

struct HourlyWeatherApi: Codable, Hashable {
    let hour: String
    let temperature: Int
    let condition: String
    let humidity: Int
    let windSpeed: Int

    enum CodingKeys: String, CodingKey {
        case hour, temperature, condition, humidity
        case windSpeed = "wind_speed" // el json viene así, para no modificar el json coloco esto [Julián]
    }
}

func loadJSON<T: Decodable>(filename: String) -> T {
    guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
        fatalError("No se pudo encontrar el archivo \(filename) en el bundle.")
    }
    
    do {
        let data = try Data(contentsOf: url)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    } catch {
        fatalError("Error al cargar el archivo JSON \(filename): \(error.localizedDescription)")
    }
}
