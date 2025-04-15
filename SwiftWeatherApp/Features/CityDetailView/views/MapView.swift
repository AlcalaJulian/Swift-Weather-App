//
//  MapView.swift
//  SwiftWeatherApp
//
//  Created by Johan Charles on 20/1/25.
//

import SwiftUI
import MapKit
/*
 struct MapView: View {
 @State var city: CityDto
 @State private var selection: MapSelection<MKMapItem>?
 let geocoder = CLGeocoder()
 
 var body: some View {
 Map{
 
 Annotation(city.city, coordinate: city.getCLLocation()) {
 if let weather = city.getCurrentWeatherHour(){
 
 ZStack{
 
 RoundedRectangle(cornerRadius: 7)
 .fill(.white)
 .padding(2)
 
 
 RoundedRectangle(cornerRadius: 7)
 .stroke(.black, lineWidth: 2)
 VStack{
 weather.getConditionIcon()
 .resizable()
 .frame(width: 40, height: 40)
 .padding(.top, 12)
 Image(systemName: "\(weather.temperature).square.fill")
 .resizable()
 .scaledToFill()
 .frame(width: 40, height: 40)
 .cornerRadius(10)
 .padding()
 //                                .background(.black)
 .foregroundStyle(.white)
 }.padding(.horizontal, 2)
 .padding(.bottom,2)
 .background(.primary)
 
 }
 
 }
 }
 
 
 //                Marker(city.city,
 //                       image: city.weather.first!.hourly.first!.condition.lowercased(),
 //                       coordinate: CLLocationCoordinate2D(latitude:city.location.latitude,
 //                                                                                                                                      longitude: city.location.longitude))
 //
 //                    .tag(MapSelection(
 //                        MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:city.location.latitude,
 //                                                longitude: city.location.longitude)))))
 //                    .mapItemDetailSelectionAccessory(.callout)
 
 }
 .mapControls{
 MapCompass()
 MapPitchToggle()
 }
 .mapControlVisibility(.visible)
 .mapFeatureSelectionAccessory(.callout)
 }
 }
 
 
 //#Preview {
 //    let previewCity = CityDto(
 //        id: "1",
 //        city: "Madrid",
 //        isFavorite: true,
 //        location: LocationDto(latitude: 40.4168, longitude: -3.7038),
 //        weather: [
 //            WeatherDto(
 //                day: "2024-11-25",
 //                hourly: [
 //                    HourlyWeatherDto(hour: "00:00", temperature: 15, condition: "Sunny", humidity: 40, windSpeed: 10),
 //                    HourlyWeatherDto(hour: "06:00", temperature: 16, condition: "Cloudy", humidity: 42, windSpeed: 12),
 //                    HourlyWeatherDto(hour: "12:00", temperature: 20, condition: "Rainy", humidity: 50, windSpeed: 15)
 //                ]
 //            ),
 //            WeatherDto(
 //                day: "2024-11-26",
 //                hourly: [
 //                    HourlyWeatherDto(hour: "00:00", temperature: 14, condition: "Partly Cloudy", humidity: 45, windSpeed: 8),
 //                    HourlyWeatherDto(hour: "12:00", temperature: 22, condition: "Sunny", humidity: 35, windSpeed: 5)
 //                ]
 //            )
 //        ]
 //    )
 //    MapView(city: previewCity)
 //}
 */
