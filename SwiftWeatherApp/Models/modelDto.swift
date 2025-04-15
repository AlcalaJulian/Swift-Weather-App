//
//  modelDto.swift
//  SwiftWeatherApp
//
//  Created by Johan Charles on 27/3/25.
//
import Foundation
import SwiftUICore
import MapKit

struct CityDto: Identifiable, Hashable {
    var id: String
    let city: String
    var isFavorite: Bool
    let location: LocationDto
    let currentWeather: CurrentWeatherDto
    let weather: [WeatherDto]

    func getCLLocation() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }

    init(from apiModel: WeatherApi, cityName: String) {
        self.id = cityName
        self.city = cityName
        self.isFavorite = false
        self.location = LocationDto(latitude: apiModel.lat, longitude: apiModel.lon)
        self.currentWeather = CurrentWeatherDto(from: apiModel.current)
        
        self.weather = apiModel.daily.map { dailyApi in
            let date = Date(timeIntervalSince1970: TimeInterval(dailyApi.dt))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let dayName = dateFormatter.string(from: date)
            
            let hourlyForDay = apiModel.hourly.filter { hourlyApi in
                let hourlyDate = Date(timeIntervalSince1970: TimeInterval(hourlyApi.dt))
                return Calendar.current.isDate(hourlyDate, inSameDayAs: date)
            }.map { HourlyWeatherDto(from: $0) }
            
            let dailyDto = DailyWeatherDto(from: dailyApi)
            
            return WeatherDto(
                day: dayName,
                hourly: hourlyForDay,
                daily: dailyDto
            )
        }
    }

    
    init(entity: City) {
        self.id = entity.id?.uuidString ?? UUID().uuidString
        self.city = entity.cityName ?? ""
        self.isFavorite = true
        self.location = LocationDto(latitude: entity.citylocation?.latitude ?? 0.0,
                                    longitude: entity.citylocation?.longitude ?? 0.0)
        self.currentWeather = CurrentWeatherDto(from: CurrentWeatherApi(
            dt: 0, sunrise: 0, sunset: 0,
            temp: 0, feelsLike: 0, dewPoint: 0, uvi: 0,
            pressure: 0, humidity: 0, clouds: 0, visibility: 0,
            windDeg: 0, windSpeed: 0, weather: []))
        self.weather = []
    }


}

struct CurrentWeatherDto: Codable, Hashable {
    let dt: Int
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [WeatherConditionDto]

    var condition: String {
        weather.first?.description ?? ""
    }

    init(from api: CurrentWeatherApi) {
        self.dt = api.dt
        self.temp = api.temp
        self.feelsLike = api.feelsLike
        self.pressure = api.pressure
        self.humidity = api.humidity
        self.dewPoint = api.dewPoint
        self.uvi = api.uvi
        self.clouds = api.clouds
        self.visibility = api.visibility
        self.windSpeed = api.windSpeed
        self.windDeg = api.windDeg
        self.weather = api.weather.map { WeatherConditionDto(from: $0) }
    }
}



struct WeatherConditionDto: Codable, Hashable {
    let id: Int
    let main: String
    let description: String
    let icon: String

    init(from api: WeatherConditionApi) {
        self.id = api.id
        self.main = api.main
        self.description = api.description
        self.icon = api.icon
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
    let daily: DailyWeatherDto?
}

struct HourlyWeatherDto: Codable, Hashable {
    let hour: String
    let temperature: Int
    let condition: String
    let humidity: Int
    let windSpeed: Int

    func getConditionIcon() -> Image {
        switch condition.lowercased() {
        case "clear":
            return Image("clear")
        case "clouds":
            return Image("cloud")
        case "rain":
            return Image("rainy")
        case "snow":
            return Image("snow")
        case "thunderstorm":
            return Image("storm")
        case "drizzle":
            return Image("drizzle")
        case "mist", "fog", "haze":
            return Image("fog")
        default:
            return Image("clear")
        }
    }
}

struct DailyWeatherDto: Codable, Hashable {
    let min: Int
    let max: Int
    let condition: String
    let humidity: Int
    let windSpeed: Int
}
