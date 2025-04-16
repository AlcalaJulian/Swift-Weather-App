
//  LocalDataHelper.swift
//  SwiftWeatherApp
//
//  Created by Johan Charles on 25/3/25.

//
//extension CityDto {
//    init(from apiModel: CityApi, isFavorite: Bool = false) {
//        self.id = apiModel.city
//        self.city = apiModel.city
//        self.isFavorite = isFavorite
//        self.location = LocationDto(from: apiModel.location)
//        self.weather = apiModel.weather.map { WeatherDto(from: $0) }
//    }
//}
//
//extension LocationDto {
//    init(from apiModel: LocationApi) {
//        self.latitude = apiModel.latitude
//        self.longitude = apiModel.longitude
//    }
//}
//
//extension WeatherDto {
//    init(from apiModel: WeatherApi) {
//        self.day = apiModel.day
//        self.hourly = apiModel.hourly.map { HourlyWeatherDto(from: $0) }
//    }
//}
//
//extension HourlyWeatherDto {
//    init(from apiModel: HourlyWeatherApi) {
//        self.hour = apiModel.hour
//        self.temperature = apiModel.temperature
//        self.condition = apiModel.condition
//        self.humidity = apiModel.humidity
//        self.windSpeed = apiModel.windSpeed
//    }
//}

import Foundation

extension WeatherApi {
    func toWeatherDtos(timezoneOffset: Int) -> [WeatherDto] {
        return daily.map { dailyItem in
            WeatherDto(from: dailyItem, hourlyData: hourly, timezoneOffset: timezoneOffset)
        }
    }
}

extension CityDto {
    init(from apiModel: WeatherApi, isFavorite: Bool = false) {
        let location = LocationDto(latitude: apiModel.lat, longitude: apiModel.lon)
        let weather = apiModel.toWeatherDtos(timezoneOffset: apiModel.timezoneOffset)

        self.id = apiModel.timezone
        self.city = apiModel.timezone
        self.isFavorite = isFavorite
        self.location = location
        self.weather = weather
    }
}

extension WeatherDto {
    // Converts from the API's `DailyWeatherApi` + matching `HourlyWeatherApi`
    init(from daily: DailyWeatherApi, hourlyData: [HourlyWeatherApi], timezoneOffset: Int) {
        let date = Date(timeIntervalSince1970: TimeInterval(daily.dt))
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        formatter.dateFormat = "yyyy-MM-dd"
        self.day = formatter.string(from: date)

        let hourlyDtos = hourlyData
            .filter {
                let hourDate = Date(timeIntervalSince1970: TimeInterval($0.dt))
                return Calendar.current.isDate(hourDate, inSameDayAs: date)
            }
            .map { HourlyWeatherDto(from: $0, timezoneOffset: timezoneOffset) }

        self.hourly = hourlyDtos
    }
}

extension HourlyWeatherDto {
    init(from apiModel: HourlyWeatherApi, timezoneOffset: Int) {
        let date = Date(timeIntervalSince1970: TimeInterval(apiModel.dt))
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        formatter.dateFormat = "HH:mm"
        self.hour = formatter.string(from: date)

        self.temperature = Int(apiModel.temp.rounded())
        self.condition = apiModel.weather.first?.main ?? "Clear"
        self.humidity = apiModel.humidity
        self.windSpeed = Int(apiModel.windSpeed.rounded())
    }
}

func formattedDate(from timestamp: Int, format: String, timezoneOffset: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
    formatter.dateFormat = format
    return formatter.string(from: date)
}



extension CityDto {
    init(from city: City, isFavorite: Bool = true) {
        self.id = city.id!.uuidString // Usamos el nombre de la ciudad como ID o UUID si prefieres uno único.
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
