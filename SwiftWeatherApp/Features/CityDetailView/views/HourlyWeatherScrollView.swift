//
//  HourlyWeatherScrollView.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 19/1/25.
//

import SwiftUI
struct HourlyWeatherScrollView: View {
    //@State var viewModel: CityDetailViewModel
    @State var hourlyWeather: [HourlyWeatherDto]
    @EnvironmentObject private var settings: SettingsStore
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(hourlyWeather, id: \.self) { hourlyWeather in
                    VStack(spacing: 5) {
                        Text(hourlyWeather.hour)
                            .font(.caption)
                            .bold()
                        Text("\(settings.temp(Double(hourlyWeather.temperature)))")
                            .font(.title3)
                        hourlyWeather.getConditionIcon()
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(hourlyWeather.condition)
                            .font(.caption)
                            .foregroundColor(.gray)
                        HStack(spacing: 5) {
                            Image(systemName: "humidity.fill")
                                .font(.caption2)
                            Text("\(hourlyWeather.humidity)%")
                                .font(.caption2)
                        }
                        HStack(spacing: 5) {
                            Image(systemName: "wind")
                                .font(.caption2)
                            Text(settings.wind(Double(hourlyWeather.windSpeed)))
                                .font(.caption2)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
            }
            .padding(.vertical, 5)
        }
        
    }
}
