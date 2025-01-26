//
//  MapView.swift
//  SwiftWeatherApp
//
//  Created by Johan Charles on 20/1/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State var city: City
    @State private var selection: MapSelection<MKMapItem>?
    
    var body: some View {
        Map{
            
            Marker(city.city, image: city.weather.first!.hourly.first!.condition.lowercased(), coordinate: CLLocationCoordinate2D(latitude:city.location.latitude, longitude: city.location.longitude)).tag(MapSelection(MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude:city.location.latitude, longitude: city.location.longitude)))))
                .mapItemDetailSelectionAccessory(.callout)
            
        }
        .mapControls{
            MapCompass()
            MapPitchToggle()
        }
        .mapControlVisibility(.visible)
        .mapFeatureSelectionAccessory(.callout)
    }
}
