//
//  model.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 14/1/25.
//

import Foundation
import SwiftUICore
import MapKit

struct WeatherApiResponse: Decodable {
    let cities: [WeatherApi]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let singleCity = try? container.decode(WeatherApi.self) {
            self.cities = [singleCity]
        } else if let cityList = try? container.decode([WeatherApi].self) {
            self.cities = cityList
        } else {
            throw DecodingError.typeMismatch(
                [WeatherApi].self,
                DecodingError.Context(codingPath: decoder.codingPath,
                                      debugDescription: "Expected WeatherApi or [WeatherApi]")
            )
        }
    }
}

struct WeatherApi: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: CurrentWeatherApi
    let hourly: [HourlyWeatherApi]
    let daily: [DailyWeatherApi]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly, daily
    }
}

struct CurrentWeatherApi: Codable {
    let dt, sunrise, sunset: Int
    let temp, feelsLike, dewPoint, uvi: Double
    let pressure, humidity, clouds, visibility, windDeg: Int
    let windSpeed: Double
    let weather: [WeatherConditionApi]

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case dewPoint = "dew_point"
        case uvi, pressure, humidity, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
}

struct HourlyWeatherApi: Codable {
    let dt: Int
    let temp, feelsLike, dewPoint, uvi: Double
    let pressure, humidity, clouds, visibility, windDeg: Int
    let windSpeed, windGust, pop: Double
    let weather: [WeatherConditionApi]
    let rain: RainVolumeApi?

    enum CodingKeys: String, CodingKey {
        case dt, temp
        case feelsLike = "feels_like"
        case dewPoint = "dew_point"
        case uvi, pressure, humidity, clouds, visibility
        case windDeg = "wind_deg"
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case pop, weather, rain
    }
}

struct DailyWeatherApi: Codable {
    let dt, sunrise, sunset, moonrise, moonset: Int
    let moonPhase: Double
    let summary: String?
    let temp: TemperatureApi
    let feelsLike: FeelsLikeApi  
    let pressure, humidity, clouds: Int
    let dewPoint, windSpeed, windGust, pop, uvi: Double
    let windDeg: Int
    let weather: [WeatherConditionApi]
    let rain: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case summary, temp, feelsLike = "feels_like", pressure, humidity
        case dewPoint = "dew_point", windSpeed = "wind_speed", windGust = "wind_gust"
        case windDeg = "wind_deg", weather, clouds, pop, uvi, rain
    }
}

struct FeelsLikeApi: Codable {
    let day, night, eve, morn: Double
}


struct TemperatureApi: Codable {
    let day, min, max, night, eve, morn: Double
}

struct WeatherConditionApi: Codable {
    let id: Int
    let main, description, icon: String
}

struct RainVolumeApi: Codable {
    let oneHour: Double?

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
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
func fetchWeatherData(from url: URL) async throws -> [WeatherApi] {
    let (data, _) = try await URLSession.shared.data(from: url)
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase 

    let response = try decoder.decode(WeatherApiResponse.self, from: data)
    return response.cities
}
