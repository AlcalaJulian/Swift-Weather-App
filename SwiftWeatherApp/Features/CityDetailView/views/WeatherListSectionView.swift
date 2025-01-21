//
//  WeatherListSectionView.swift
//  SwiftWeatherApp
//
//  Created by Julián Alcalá Forero on 19/1/25.
//
import SwiftUI

struct WeatherListSectionView: View {
    @State var viewModel: CityDetailViewModel
    @State private var selectedOtherDay:Weather?
    
    var body : some View {
        Section {
            DisclosureGroup(
                isExpanded: $viewModel.isOtherDaysExpanded,
                content: {
                    ForEach(viewModel.otherDaysWeather, id: \.day) { weather in
                        Button(action: {
                            selectedOtherDay = weather
                        }) {
                            HStack {
                                Text(viewModel.convertStringToDateAndGetDayOfWeek(weather.day))
                                    .font(.headline)
                                weather.hourly.first!.getConditionIcon()
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
        }.sheet(item: $selectedOtherDay){ day in
            
            VStack{
                VStack{
                    CurrentTimeSectionView(hourlyWeather: day.hourly, currentDay: day.day, currentDate: viewModel.convertStringToDateAndGetDayOfWeek(day.day))
                    Button {
                        selectedOtherDay = nil
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
    }
}
