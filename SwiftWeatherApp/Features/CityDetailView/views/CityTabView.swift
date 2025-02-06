//
//  CityTabView.swift
//  SwiftWeatherApp
//
//  Created by Johan Charles on 6/2/25.
//

import SwiftUI

struct CityTabView: View {
    @State private var currentcity: City
    @State private var selected: String = ""
    
    private var backAction: () -> Void
    
    private var viewModel = CitiesListViewModel()
    @State private var isSHowingMap = false
    
    init(currentcity: City, onBack: @escaping () -> Void) {
        self.currentcity = currentcity
        selected = currentcity.city
        backAction = onBack
    }
    
    var body: some View {
        //        NavigationStack{
        VStack{
            TabView(selection: $currentcity) {
//                                    TabSection{
                                        Tab("tab section", systemImage: "circle.fill", value: currentcity) {
                                            Text("Hola mundo")
                                            Button{
                                                                isSHowingMap = true
                                                            } label: {
                                                                Image(systemName: "map")
                                                            }
                                                            .padding()
                                                            .background(.red)
                                        }
//                                    }
//                Tab(currentcity.city, systemImage: "circle.fill", value: currentcity){
//                    CityDetailView(city: currentcity)
//                }
                
                TabSection("Cities") {
                    ForEach(viewModel.cities.filter { $0.city != currentcity.city }) { city in
                        Tab(value: city) {
            CityDetailView(city: currentcity)
          
                        }
//                        Tab(city.city, systemImage:  "circle.fill", value: city) {
//                                            CityDetailView(city: city)
                        }
//                    
                    }
                }
                
            HStack{
                
                Button{
                    isSHowingMap = true
                } label: {
                    Image(systemName: "map")
                }
                .padding()
                Button{
                    backAction()
                } label: {
                    Image(systemName: "list.bullet")
                }
                .padding()
            }
            .padding()
            }.tabViewStyle(.page)
                .sheet(isPresented: $isSHowingMap) {
                    ZStack{
                        MapView(city: currentcity)
                            .ignoresSafeArea()
                        VStack{
                            Spacer()
                            MapCard(city: currentcity)
                                .shadow(color: .black.opacity(0.7), radius: 20)
                                .padding()
                        }
                    }
                    
                    .ignoresSafeArea()
                    .overlay(alignment: .topLeading) {
                        BackButtonView(onClick: { isSHowingMap.toggle() })
                    }
                    //                }
            
//        }
        
            
            
            
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
    
    CityTabView(currentcity: previewCity, onBack: {})
}
