//
//  LocalDataHelper.swift
//  SwiftWeatherApp
//
//  Created by Johan Charles on 25/3/25.
//

extension CityDto {
    init(from apiModel: CityApi, isFavorite: Bool = false) {
        self.id = apiModel.city
        self.city = apiModel.city
        self.isFavorite = isFavorite
        self.location = LocationDto(from: apiModel.location)
        self.weather = apiModel.weather.map { WeatherDto(from: $0) }
    }
}

extension LocationDto {
    init(from apiModel: LocationApi) {
        self.latitude = apiModel.latitude
        self.longitude = apiModel.longitude
    }
}

extension WeatherDto {
    init(from apiModel: WeatherApi) {
        self.day = apiModel.day
        self.hourly = apiModel.hourly.map { HourlyWeatherDto(from: $0) }
    }
}

extension HourlyWeatherDto {
    init(from apiModel: HourlyWeatherApi) {
        self.hour = apiModel.hour
        self.temperature = apiModel.temperature
        self.condition = apiModel.condition
        self.humidity = apiModel.humidity
        self.windSpeed = apiModel.windSpeed
    }
}


extension CityDto {
    init(from city: City, isFavorite: Bool = true) {
        self.id = city.id!.uuidString
        self.city = city.cityName!
        self.isFavorite = isFavorite
        self.location = LocationDto(from: city.citylocation)
        self.weather = city.cityweather?.compactMap { WeatherDto(from: $0 as! Weather) } ?? []
    }
}


extension LocationDto {
    init(from apiModel: Location?) {
        self.latitude = apiModel?.latitude ?? 0
        self.longitude = apiModel?.longitude ?? 0
    }
}


extension WeatherDto {
    init(from weather: Weather) {
        self.day = weather.day ?? "Día desconocido"
        self.hourly = weather.weatherhourly?.compactMap { HourlyWeatherDto(from: $0 as! HourlyWeather) } ?? []
    }
}


extension HourlyWeatherDto {
    init(from hour: HourlyWeather) {
        self.hour = hour.hourly!
        self.temperature = Int(hour.temperature)
        self.condition = hour.condition!
        self.humidity = Int(hour.humidity)
        self.windSpeed = Int(hour.windSpeed)
    }
}
