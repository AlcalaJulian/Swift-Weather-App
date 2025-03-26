//
//  CityRow.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 18/1/25.
//

import SwiftUI

struct CityRow: View {
    let city: CityDto
    var weather: [Weather] = []
    
    var body: some View {
        if let firstWeather = weather.first, !firstWeather.hourly.isEmpty {
            let hourly = firstWeather.hourly
            let firstTemp = hourly.first!.temperature
            let condition = hourly.first!.condition
            let temperatures = hourly.map { $0.temperature }
            
            if let maxTemp = temperatures.max(), let minTemp = temperatures.min() {
                CityRowContentView(city: city,
                            condition: "\(condition)",
                            firstTemp: Double(firstTemp),
                            maxTemp: Double(maxTemp),
                            minTemp: Double(minTemp))
            } else {
                CityRowFallbackView(city: city.city)
            }
        } else {
            CityRowFallbackView(city: city.city)
        }
    }
}

struct CityRowContentView: View {
    let city: CityDto
    let condition: String
    let firstTemp: Double
    let maxTemp: Double
    let minTemp: Double
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(city.city)
                    .font(.system(size: 22))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Text(condition)
                    .font(.system(size: 16))
                    .foregroundColor(colorScheme == .dark ? .white.opacity(0.9) : .black.opacity(0.9))
            }
            .padding(.leading, 16)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(firstTemp, specifier: "%.0f")°")
                    .font(.system(size: 48))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Text("Máx: \(maxTemp, specifier: "%.0f")°  •  Mín: \(minTemp, specifier: "%.0f")°")
                    .font(.system(size: 14))
                    .foregroundColor(colorScheme == .dark ? .white.opacity(0.85) : .black.opacity(0.85))
            }
            .padding(.trailing, 16)
        }
        .padding(.vertical, 16)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    colorScheme == .dark ? Color.blue.opacity(0.6) : Color.blue.opacity(0.4),
                    colorScheme == .dark ? Color.gray.opacity(0.7) : Color(.lightGray).opacity(0.7)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
    }
}

struct CityRowFallbackView: View {
    let city: String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            Text(city)
                .font(.headline)
                .foregroundColor(colorScheme == .dark ? .white : .gray)
            Spacer()
            Text("Sin datos meteorológicos")
                .font(.subheadline)
                .foregroundColor(colorScheme == .dark ? .white : .gray)
        }
        .padding()
        .background(colorScheme == .dark ? Color.black.opacity(0.8) : Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}
