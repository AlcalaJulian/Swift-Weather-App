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
                viewModel.getConditionIcon(for: viewModel.currentWeather.weather.first!.main)
                    .resizable()
                    .frame(width: 120, height: 120)
                Text(viewModel.currentTemperature)
                    .font(.system(size: 58))
                Text(viewModel.currentCondition)
                Text("Sensación: \(Int(viewModel.feelsLike()))°")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(Color.clear)
        }
    }
}
