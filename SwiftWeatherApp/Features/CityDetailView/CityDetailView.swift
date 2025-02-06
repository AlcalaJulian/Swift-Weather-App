//
//  CityDetail.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 14/1/25.
//

import SwiftUI

struct CityDetailView: View {
    @State private var viewModel: CityDetailViewModel
    @State private var isSHowingMap = false
    
    init(city: City) {
        _viewModel = State(wrappedValue: CityDetailViewModel(city: city))
    }
    
    var body: some View {
        VStack{
            List {
                CurrentTimeHeaderSectionView(viewModel:viewModel)
                CurrentTimeSectionView(hourlyWeather: viewModel.hourlyWeather, currentDay: viewModel.currentDay, currentDate: viewModel.currentDate)
                WeatherListSectionView(viewModel:viewModel)
                
            }
            .navigationTitle(viewModel.navigationTitle)
            .sheet(item: $viewModel.selectedOtherDay){ day in
                
                VStack{
                    VStack{
                        CurrentTimeSectionView(hourlyWeather: day.hourly, currentDay: day.day, currentDate: viewModel.convertStringToDateAndGetDayOfWeek(day.day))
                        Button {
                            viewModel.handleWeatherTap(for: nil)
                        } label: {
                            
                            Text("OK")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .buttonStyle(.bordered)
                            .background(.blue)
                        }
                        
                    }.padding(.top, 15)
                        .padding([.horizontal, .bottom], 15)
                        .background(.background, in: .rect(cornerRadius: 15))
                        .shadow(color:.black.opacity(0.12), radius: 8)
                        .padding(.horizontal, 5)
                    
                }
                .presentationCornerRadius(0)
                .presentationBackground(.clear)
                .padding(.horizontal, 15)
                    .padding(.top, 5)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(400)))
                
            }
            .sheet(isPresented: $isSHowingMap) {
                ZStack{
                    MapView(city: viewModel.city)
                        .ignoresSafeArea()
                    VStack{
                        Spacer()
                        MapCard(city: viewModel.city)
                            .shadow(color: .black.opacity(0.7), radius: 20)
                            .padding()
                    }
                }
                
                .ignoresSafeArea()
                .overlay(alignment: .topLeading) {
                    BackButtonView(onClick: { isSHowingMap.toggle() })
                }
                
            }
            
        }
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
