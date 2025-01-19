//
//  HourlyWeatherScrollView.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 19/1/25.
//

import SwiftUI
struct HourlyWeatherScrollView: View {
    @State var viewModel: CityDetailViewModel
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.hourlyWeather, id: \.self) { hourlyWeather in
                    VStack(spacing: 5) {
                        Text(hourlyWeather.hour)
                            .font(.caption)
                            .bold()
                        Text("\(hourlyWeather.temperature)°C")
                            .font(.title3)
                        viewModel.getConditionIcon(for: hourlyWeather.condition)
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
                            Text("\(hourlyWeather.windSpeed) km/h")
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
