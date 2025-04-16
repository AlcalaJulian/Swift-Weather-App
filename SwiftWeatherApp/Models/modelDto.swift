//
//  modelDto.swift
//  SwiftWeatherApp
//
//  Created by Johan Charles on 27/3/25.
//
//
//  model.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 14/1/25.
//

import Foundation
import SwiftUICore
import MapKit


struct CityDto: Identifiable, Hashable {
    var id: String
    let city: String
    var isFavorite: Bool
    let location: LocationDto
    let weather: [WeatherDto]
    
    func getCLLocation() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    
    init(id: String = UUID().uuidString, city: String, isFavorite: Bool = false, location: LocationDto, weather: [WeatherDto]) {
            self.id = id
            self.city = city
            self.isFavorite = isFavorite
        
            self.location = location
            self.weather = weather
        }
    
    
    func getCurrentWeatherHour() -> HourlyWeatherDto? {
        
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

struct LocationDto: Codable, Hashable {
    let latitude: Double
    let longitude: Double
}

struct WeatherDto: Codable, Hashable, Identifiable {
    var id: String { day }
    let day: String
    let hourly: [HourlyWeatherDto]
}

struct HourlyWeatherDto: Codable, Hashable {
    let hour: String
    let temperature: Int
    let condition: String
    let humidity: Int
    let windSpeed: Int

//    enum CodingKeys: String, CodingKey {
//        case hour, temperature, condition, humidity
//        case windSpeed = "wind_speed" // el json viene así, para no modificar el json coloco esto [Julián]
//    }
    
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


