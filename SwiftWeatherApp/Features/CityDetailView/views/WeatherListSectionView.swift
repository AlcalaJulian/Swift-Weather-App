//
//  WeatherListSectionView.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 19/1/25.
//
import SwiftUI

struct WeatherListSectionView: View {
    @State var viewModel: CityDetailViewModel
    
    var body: some View {
        Section {
            DisclosureGroup(
                isExpanded: $viewModel.isOtherDaysExpanded,
                content: {
                    ForEach(viewModel.otherDaysWeather, id: \.self) { daily in
                        Button(action: {
                        }) {
                            HStack {
                                Text("Day: \(daily.condition)")
                                    .font(.headline)
                                Text("Min: \(daily.min)° / Max: \(daily.max)°")
                                    .font(.caption)
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

