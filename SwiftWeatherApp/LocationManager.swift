//
//  LocationManager.swift
//  SwiftWeatherApp
//
//  Created by Johan Charles on 6/2/25.
//

import SwiftUI
import MapKit

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate{
    
    var location: CLLocation?
    
    private let locationManager = CLLocationManager()
    
    override init(){
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        location = newLocation
        //manager.stopUpdatingLocation()
    }
}
