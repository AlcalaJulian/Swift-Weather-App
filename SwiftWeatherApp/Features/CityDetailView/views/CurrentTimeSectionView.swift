//
//  CurrentTimeSectionView.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 19/1/25.
//
import SwiftUI

struct CurrentTimeSectionView: View {
    @State var viewModel: CityDetailViewModel
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(viewModel.currentDay)
                        .font(.headline)
                    Spacer()
                    Text(viewModel.currentDate)
                }
                HourlyWeatherScrollView(viewModel: viewModel)
            }
        }
    }
}


