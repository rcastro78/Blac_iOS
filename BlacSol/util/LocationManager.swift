//
//  LocationManager.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 1/5/25.
//
import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var location: CLLocationCoordinate2D?
    
        override init() {
            super.init()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let loc = locations.first {
                location = loc.coordinate
                manager.stopUpdatingLocation() // detener para no seguir actualizando
            }
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error al obtener la ubicación: \(error.localizedDescription)")
        }
    
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
        }
    }
}

