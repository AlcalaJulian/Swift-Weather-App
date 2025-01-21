//
//  model.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 14/1/25.
//

import Foundation
import SwiftUICore

struct Forecast: Codable {
    let cities: [City]
}

struct City: Codable, Hashable, Identifiable {
    var id: String { city }
    
    let city: String
    let location: Location
    let weather: [Weather]
}

struct Location: Codable, Hashable {
    let latitude: Double
    let longitude: Double
}

struct Weather: Codable, Hashable, Identifiable {
    var id: String { day }
    let day: String
    let hourly: [HourlyWeather]
}

struct HourlyWeather: Codable, Hashable {
    let hour: String
    let temperature: Int
    let condition: String
    let humidity: Int
    let windSpeed: Int

    enum CodingKeys: String, CodingKey {
        case hour, temperature, condition, humidity
        case windSpeed = "wind_speed" // el json viene así, para no modificar el json coloco esto [Julián]
    }
    
    func getConditionIcon() -> Image {
        switch condition.lowercased() {
        case "clear", "sunny":
            return Image("sunny")
        case "cloudy":
            return Image("cloud")
        case "rainy":
            return Image("rainy")
        default:
            return Image("cloudy")
        }
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
