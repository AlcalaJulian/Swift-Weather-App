//
//  CityDetail.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 14/1/25.
//

import SwiftUI

struct CityDetailView: View {
    @State private var viewModel: CityDetailViewModel
    
    init(city: City) {
        _viewModel = State(wrappedValue: CityDetailViewModel(city: city))
    }
    
    var body: some View {
        List {
            CurrentTimeHeaderSectionView(viewModel:viewModel)
            CurrentTimeSectionView(viewModel:viewModel)
            WeatherListSectionView(viewModel:viewModel)
        }
        .navigationTitle(viewModel.navigationTitle)
    }
}


#Preview {
    let previewCity = City(
        city: "Madrid",
        location: Location(latitude: 40.4168, longitude: -3.7038),
        weather: [
            Weather(
                day: "2024-11-25",
                hourly: [
                    HourlyWeather(hour: "00:00", temperature: 15, condition: "Sunny", humidity: 40, windSpeed: 10),
                    HourlyWeather(hour: "06:00", temperature: 16, condition: "Cloudy", humidity: 42, windSpeed: 12),
                    HourlyWeather(hour: "12:00", temperature: 20, condition: "Rainy", humidity: 50, windSpeed: 15)
                ]
            ),
            Weather(
                day: "2024-11-26",
                hourly: [
                    HourlyWeather(hour: "00:00", temperature: 14, condition: "Partly Cloudy", humidity: 45, windSpeed: 8),
                    HourlyWeather(hour: "12:00", temperature: 22, condition: "Sunny", humidity: 35, windSpeed: 5)
                ]
            )
        ]
    )
    
    return CityDetailView(city: previewCity)
}
