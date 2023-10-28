//
//  LocationManager.swift
//  LocationButton
//
//  Created by Steven Yung on 10/27/23.
//

import Foundation
import MapKit

@MainActor
class LocationManager: NSObject, ObservableObject {
    @Published var currentLocation: CLLocation?
    @Published var currentRegion = MKCoordinateRegion()
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentLocation = location
        self.currentRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000.0, longitudinalMeters: 5000.0)
        locationManager.stopUpdatingLocation()
    }
}

// other stuff
extension CLLocationCoordinate2D {
    static let appleHQLoc = CLLocationCoordinate2D(latitude: 37.3359404078055, longitude: -122.0083711891967)
}
extension MKCoordinateRegion {
    static let appleHQReg = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3359404078055, longitude: -122.0083711891967),
        latitudinalMeters: 5000.0, longitudinalMeters: 5000.0
    )
}
