//
//  WeatherListSectionView.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 19/1/25.
//
import SwiftUI

struct WeatherListSectionView: View {
    @State var viewModel: CityDetailViewModel
    @EnvironmentObject private var settings: SettingsStore

    var body: some View {
        Section {
            DisclosureGroup(
                isExpanded: $viewModel.isOtherDaysExpanded,
                content: {
                    ForEach(viewModel.otherDaysWeather, id: \.day) { weather in
                        Button {
                            viewModel.handleWeatherTap(for: weather)
                        } label: {
                            HStack {
                                Text(viewModel.convertStringToDateAndGetDayOfWeek(weather.day))
                                    .font(.headline)
                                weather.hourly.first!.getConditionIcon()
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text(
                                    viewModel.temperatureRange(
                                        from: weather.hourly.map(\.temperature),
                                        unit: settings.temperatureUnit 
                                    )
                                )
                            }
                            .padding(.vertical, 5)
                        }
                        .buttonStyle(.plain)
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
