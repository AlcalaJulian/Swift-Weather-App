//
//  MapView.swift
//  SwiftWeatherApp
//
//  Created by Johan Charles on 20/1/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State var city: CityDto
    @State private var selection: MapSelection<MKMapItem>?
    let geocoder = CLGeocoder()
    
    var body: some View {
        Map {
            Annotation(city.city, coordinate: city.getCLLocation()) {
                if let weather = city.getCurrentWeatherHour() {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 5)

                        VStack(spacing: 6) {
                            weather.getConditionIcon()
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                        .padding(8)
                    }
                }
            }
        }
        .mapControls{
            MapCompass()
            MapPitchToggle()
        }
        .mapControlVisibility(.visible)
        .mapFeatureSelectionAccessory(.callout)
    }
}


#Preview {
    let previewCity = CityDto(
        id: "1",
        city: "Madrid",
        isFavorite: true,
        location: LocationDto(latitude: 40.4168, longitude: -3.7038),
        weather: [
            WeatherDto(
                day: "2024-11-25",
                hourly: [
                    HourlyWeatherDto(hour: "00:00", temperature: 15, condition: "Sunny", humidity: 40, windSpeed: 10),
                    HourlyWeatherDto(hour: "06:00", temperature: 16, condition: "Cloudy", humidity: 42, windSpeed: 12),
                    HourlyWeatherDto(hour: "12:00", temperature: 20, condition: "Rainy", humidity: 50, windSpeed: 15)
                ]
            ),
            WeatherDto(
                day: "2024-11-26",
                hourly: [
                    HourlyWeatherDto(hour: "00:00", temperature: 14, condition: "Partly Cloudy", humidity: 45, windSpeed: 8),
                    HourlyWeatherDto(hour: "12:00", temperature: 22, condition: "Sunny", humidity: 35, windSpeed: 5)
                ]
            )
        ]
    )
    MapView(city: previewCity)
}
