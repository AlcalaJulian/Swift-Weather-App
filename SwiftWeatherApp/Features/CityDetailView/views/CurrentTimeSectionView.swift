//
//  CurrentTimeSectionView.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 19/1/25.
//
import SwiftUI

struct CurrentTimeSectionView: View {
    //@State var viewModel: CityDetailViewModel
    var hourlyWeather:[HourlyWeatherDto]
    var currentDay: String
    var currentDate: String
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(currentDay)
                        .font(.headline)
                    Spacer()
                    Text(currentDate)
                }
                HourlyWeatherScrollView(hourlyWeather: hourlyWeather)
            }
        }
    }
}


