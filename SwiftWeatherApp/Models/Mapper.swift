//
//  LocalDataHelper.swift
//  SwiftWeatherApp
//
//  Created by Johan Charles on 25/3/25.
//

// Adaptación del nuevo modelo WeatherApi al dominio CityDto

import Foundation

extension CityDto {
    init(from apiModel: WeatherApi, cityName: String, isFavorite: Bool = false) {
        self.id = cityName
        self.city = cityName
        self.isFavorite = isFavorite
        self.location = LocationDto(latitude: apiModel.lat, longitude: apiModel.lon)
        self.currentWeather = CurrentWeatherDto(from: apiModel.current)
        self.weather = [WeatherDto(from: apiModel)]
    }
}

extension CityDto {
    init(entity city: City, isFavorite: Bool = true) {
        self.id = city.id?.uuidString ?? UUID().uuidString
        self.city = city.cityName ?? "Ciudad desconocida"
        self.isFavorite = isFavorite
        self.location = LocationDto(entity: city.citylocation)
        self.currentWeather = CurrentWeatherDto(from: CurrentWeatherApi(
                    dt: 0,
                    sunrise: 0,
                    sunset: 0,
                    temp: 0,
                    feelsLike: 0,
                    dewPoint: 0,
                    uvi: 0,
                    pressure: 0,
                    humidity: 0,
                    clouds: 0,
                    visibility: 0,
                    windDeg: 0,
                    windSpeed: 0,
                    weather: []))
        self.weather = []
    }
}

extension LocationDto {
    /// Inicializa un LocationDto desde una entidad `Location` de Core Data
    init(entity: Location?) {
        self.latitude = entity?.latitude ?? 0
        self.longitude = entity?.longitude ?? 0
    }
}

extension WeatherDto {
    init(from apiModel: WeatherApi) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.day = formatter.string(from: Date())
        self.hourly = apiModel.hourly.map { HourlyWeatherDto(from: $0) }
        self.daily = apiModel.daily.first.map { DailyWeatherDto(from: $0) }
    }
}


extension HourlyWeatherDto {
    init(from apiModel: HourlyWeatherApi) {
        let date = Date(timeIntervalSince1970: TimeInterval(apiModel.dt))
        self.hour = date.formattedHour()
        self.temperature = Int(apiModel.temp.rounded())
        self.condition = apiModel.weather.first?.main ?? "Desconocido"
        self.humidity = apiModel.humidity
        self.windSpeed = Int(apiModel.windSpeed.rounded())
    }
}


extension DailyWeatherDto {
    init(from apiModel: DailyWeatherApi) {
        self.min = Int(apiModel.temp.min.rounded())
        self.max = Int(apiModel.temp.max.rounded())
        self.condition = apiModel.weather.first?.main ?? "Desconocido"
        self.humidity = apiModel.humidity
        self.windSpeed = Int(apiModel.windSpeed.rounded())
    }
}



extension Date {
    func formattedHour() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    func formattedDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
}

