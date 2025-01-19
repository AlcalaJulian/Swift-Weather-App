//
//  CurrentTimeHeaderSectionView.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 19/1/25.
//
import SwiftUI

struct CurrentTimeHeaderSectionView: View {
    @State var viewModel: CityDetailViewModel
    
    var body: some View {
        Section {
            VStack {
                viewModel.getConditionIcon(for: viewModel.currentCondition)
                    .resizable()
                    .frame(width: 150, height: 150)
                Text(viewModel.currentTemperature)
                    .font(.system(size: 58))
                Text(viewModel.currentCondition)
                Text(viewModel.temperatureRange(from: viewModel.hourlyWeather.map { $0.temperature }))
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(Color.clear)
        }
    }
}
