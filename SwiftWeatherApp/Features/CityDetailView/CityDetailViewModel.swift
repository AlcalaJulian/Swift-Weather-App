//
//  CityDetailViewModel.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 19/1/25.
//

import Foundation
import SwiftUI

@Observable
class CityDetailViewModel: ObservableObject {
    var isExpanded = true
    var isOtherDaysExpanded = false
    var selectedOtherDay: WeatherDto?
    private let _context: CoreDataStack = CoreDataStack.shared
    
    var city: CityDto
    
    init(city: CityDto) {
        self.city = city
    }
    
    var navigationTitle: String {
        city.city
    }
    
    var currentWeather: CurrentWeatherDto {
        city.currentWeather
    }
    
    var currentTemperature: String {
        "\(Int(currentWeather.temp))°"
    }
    
    var currentCondition: String {
        currentWeather.condition.capitalized
    }
    
    var currentDay: String {
        let date = Date(timeIntervalSince1970: TimeInterval(currentWeather.dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    var currentDate: String {
        let date = Date(timeIntervalSince1970: TimeInterval(currentWeather.dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium 
        return dateFormatter.string(from: date)
    }
    
    var hourlyWeather: [HourlyWeatherDto] {
        return city.weather.first?.hourly ?? []
    }
    
    var otherDaysWeather: [DailyWeatherDto] {
        return city.weather.compactMap { $0.daily }
    }

    
    func feelsLike() -> Double {
        return currentWeather.feelsLike
    }
    
    func getConditionIcon(for condition: String) -> Image {
        switch condition {
        case "Sunny":
            return Image("sunny")
        case "Clouds":
            return Image("cloud")
        case "Clear":
            return Image("clear")
        case "Rain":
            return Image("rainy")
        default:
            return Image("cloudy")
        }
    }
    
    func handleWeatherTap(for weather: WeatherDto?) {
        selectedOtherDay = weather
    }
    
    func addToFavorites() async {
        let newCity = City(context: _context.container.viewContext)
        newCity.id = UUID()
        newCity.cityName = city.city
        
        newCity.citylocation?.latitude = city.location.latitude
        newCity.citylocation?.longitude = city.location.longitude
        
        city.weather.forEach {
            let weatherEntity = Weather(context: _context.container.viewContext)
            weatherEntity.day = $0.day
            
            $0.hourly.forEach { hourlyDto in
                let hourly = HourlyWeather(context: _context.container.viewContext)
                hourly.condition = hourlyDto.condition
                hourly.hourly = hourlyDto.hour
                hourly.humidity = Int16(hourlyDto.humidity)
                hourly.temperature = Int16(hourlyDto.temperature)
                hourly.windSpeed = Int16(hourlyDto.windSpeed)
                
                weatherEntity.addToWeatherhourly(hourly)
            }
            
            newCity.addToCityweather(weatherEntity)
        }
        
        await _context.add(newCity)
        city.id = newCity.id!.uuidString
        city.isFavorite.toggle()
    }
        
    func removeFromFavorites() async {
        let cityToDelete = try? _context.container.viewContext.fetch(_context.requestById(UUID(uuidString: city.id)!)).first
        if let toDelete = cityToDelete {
            _context.delete(item: toDelete)
            city.id = city.city
            city.isFavorite.toggle()
        }
    }
}
