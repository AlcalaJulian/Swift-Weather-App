//
//  WeatherListSectionView.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 19/1/25.
//
import SwiftUI

struct WeatherListSectionView: View {
    @State var viewModel: CityDetailViewModel
    
    var body : some View {
        Section {
            DisclosureGroup(
                isExpanded: $viewModel.isOtherDaysExpanded,
                content: {
                    ForEach(viewModel.otherDaysWeather, id: \.day) { weather in
                        Button(action: {
                            viewModel.handleWeatherTap(for: weather)
                        }) {
                            HStack {
                                Text(viewModel.convertStringToDateAndGetDayOfWeek(weather.day))
                                    .font(.headline)
                                viewModel.getConditionIcon(for: weather.hourly.first!.condition)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text(viewModel.temperatureRange(from: weather.hourly.map { $0.temperature }))
                            }
                            .padding(.vertical, 5)
                        }
                        .buttonStyle(PlainButtonStyle()) 
                    }
                },
                label: {
                    HStack {
                        Text("Other Days")
                        Spacer()
                        Image("calendar")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
            )
        }
    }
}
