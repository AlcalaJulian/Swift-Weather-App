//
//  CityRow.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 18/1/25.
//
import SwiftUI

struct CityRow: View {
    let city: City
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
                CityRowFallbackView(city: city)
            }
        } else {
            CityRowFallbackView(city: city)
        }
    }
}

/// Vista principal con el diseño mejorado
struct CityRowContentView: View {
    let city: City
    let condition: String
    let firstTemp: Double
    let maxTemp: Double
    let minTemp: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(city.city)
                    .font(.system(size: 22))
                    .foregroundColor(.black)
                Text(condition)
                    .font(.system(size: 16))
                    .foregroundColor(.black.opacity(0.9))
            }
            .padding(.leading, 16)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(firstTemp, specifier: "%.0f")°")
                    .font(.system(size: 48))
                    .foregroundColor(.black)
                
                Text("Máx: \(maxTemp, specifier: "%.0f")°  •  Mín: \(minTemp, specifier: "%.0f")°")
                    .font(.system(size: 14))
                    .foregroundColor(.black.opacity(0.85))
            }
            .padding(.trailing, 16)
        }
        .padding(.vertical, 16)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.4),
                    Color(.lightGray).opacity(0.7)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
    }
}

struct CityRowFallbackView: View {
    let city: City
    
    var body: some View {
        HStack {
            Text(city.city)
                .font(.headline)
                .foregroundColor(.gray)
            Spacer()
            Text("Sin datos meteorológicos")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}
