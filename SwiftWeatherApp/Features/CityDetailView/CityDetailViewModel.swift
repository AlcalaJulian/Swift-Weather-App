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
    
    let city: City
    
    init(city: City) {
        self.city = city
    }
    
    var navigationTitle: String {
        city.city
    }
    
    var currentWeather: HourlyWeather? {
        city.weather.first?.hourly.first
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
    
    var hourlyWeather: [HourlyWeather] {
        city.weather.first?.hourly ?? []
    }
    
    var otherDaysWeather: [Weather] {
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
    func handleWeatherTap(for weather: Weather) {
           
        // TODO
       }
}
