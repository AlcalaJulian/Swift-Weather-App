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
    
    var currentWeather: HourlyWeatherDto? {
        
        city.getCurrentWeatherHour()
    }
    
    var currentTemperature: String {
        "\(Int(currentWeather?.temperature ?? 0))°"
    }
    
    var currentCondition: String {
        currentWeather?.condition ?? "Sunny"
    }
    
    var currentDay: String {
        convertStringToDateAndGetDayOfWeek(city.weather.first?.day ?? "")
    }
    
    var currentDate: String {
        city.weather.first?.day ?? ""
    }
    
    var hourlyWeather: [HourlyWeatherDto] {
        city.weather.first?.hourly ?? []
    }
    
    var otherDaysWeather: [WeatherDto] {
        Array(city.weather.dropFirst())
    }
    
    func temperatureRange(from temperatures: [Int]) -> String {
        guard let maxTemp = temperatures.max(), let minTemp = temperatures.min() else {
            return ""
        }
        return "Max: \(maxTemp)°C - Min: \(minTemp)°C"
    }
    
    func getConditionIcon(for condition: String) -> Image {
        switch condition.lowercased() {
        case "sunny":
            return Image("sunny")
        case "cloudy":
            return Image("cloud")
        case "rainy":
            return Image("rainy")
        default:
            return Image("cloudy")
        }
    }
    
    func convertStringToDateAndGetDayOfWeek(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.locale = Locale.current
        
        guard let date = dateFormatter.date(from: dateString) else {
            return "Unknown"
        }
        
        let calendar = Calendar.current
        let weekdayIndex = calendar.component(.weekday, from: date) - 1
        
        guard let weekdaySymbols = dateFormatter.weekdaySymbols,
              weekdayIndex < weekdaySymbols.count else {
            return "Unknown"
        }
        
        return weekdaySymbols[weekdayIndex]
    }
    
    func handleWeatherTap(for weather: WeatherDto?) {
        selectedOtherDay = weather
    }
    
    func addToFavorites() async {
            // Lógica para agregar la ciudad a favoritos
        let newCity = City(context: _context.container.viewContext)
        newCity.id = UUID()
        newCity.cityName = city.city
        
        newCity.citylocation?.latitude = city.location.latitude
        newCity.citylocation?.longitude = city.location.longitude
        
        city.weather.forEach{
            let weather = Weather(context: _context.container.viewContext)
            weather.day = $0.day
            
            $0.hourly.forEach { HourlyDto in
                let hourly = HourlyWeather(context: _context.container.viewContext)
                hourly.condition = HourlyDto.condition
                hourly.hourly = HourlyDto.hour
                hourly.humidity = Int32(HourlyDto.humidity)
                hourly.temperature = Int32(HourlyDto.temperature)
                hourly.windSpeed = Int32(HourlyDto.windSpeed)
                
                weather.addToWeatherhourly(hourly)
            }
            
            newCity.addToCityweather(weather)
        }
        
        await _context.add(newCity)
        city.id = newCity.id!.uuidString
        city.isFavorite.toggle()
    }
        
    func removeFromFavorites() async {
            // Lógica para eliminar la ciudad de favoritos
        
        let cityToDelete = try? _context.container.viewContext.fetch(_context.requestById(UUID(uuidString: city.id)!)).first
        if let toDelete = cityToDelete {
            _context.delete(item: toDelete)
            city.id = city.city
            city.isFavorite.toggle()
        }
    }
}
