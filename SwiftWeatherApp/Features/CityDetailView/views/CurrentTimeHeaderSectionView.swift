//
//  CurrentTimeHeaderSectionView.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 19/1/25.
//
import SwiftUI

struct CurrentTimeHeaderSectionView: View {
    @State var viewModel: CityDetailViewModel
    @EnvironmentObject private var settings: SettingsStore

    
    var body: some View {
        Section {
            VStack {
                viewModel.currentWeather?.getConditionIcon()
                    .resizable()
                    .frame(width: 120, height: 120)
                Text(settings.temp(viewModel.currentTemperature))
                    .font(.system(size: 58))
                Text(viewModel.currentCondition)
                Text(
                    viewModel.temperatureRange(
                        from: viewModel.hourlyWeather.map(\.temperature),
                        unit: settings.temperatureUnit))
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(Color.clear)
        }
    }
}
