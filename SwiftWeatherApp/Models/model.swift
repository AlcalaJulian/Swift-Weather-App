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
    let cities: [City]
}

struct City: Codable, Hashable, Identifiable {
    var id: String { city }
    
    let city: String
    let location: Location
    let weather: [Weather]
    
    func getCLLocation() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    
    
    func getCurrentWeatherHour() -> HourlyWeather? {
        
        let now = Date.now
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dateString = dateFormatter.string(from: now)
        
        let currentWeather = weather.first { $0.day == dateString } ?? weather.first
        
        dateFormatter.dateFormat = "hh:mm"
        let hour = dateFormatter.string(from: now)
        
        return currentWeather?.hourly.first { $0.hour == hour } ?? currentWeather?.hourly.first
    }
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
        case "sunny":
            return Image("sunny")
        case "cloudy":
            return Image("cloud")
        case "rainy":
            return Image("rainy")
        default:
            return Image("clear")
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
