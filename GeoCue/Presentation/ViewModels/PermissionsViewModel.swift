//
//  PermissionsViewModel.swift
//  GeoCue
//
//  Created by Haris  on 15/02/2025.
//

import MapKit

final class PermissionsViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    private var locationManager: CLLocationManager?

    func checkLocationServicesEnabled() {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let servicesEnabled = CLLocationManager.locationServicesEnabled()
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if servicesEnabled {
                        self.locationManager = CLLocationManager()
                        self.locationManager?.delegate = self
                        self.checkLocationAuthorization()
                    } else {
                        print("Location services are turned off.")
                        self.authorizationStatus = .denied
                    }
                }
            }
        }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        // Update published property with current status.
        authorizationStatus = locationManager.authorizationStatus
         let status = locationManager.authorizationStatus
        print("Current authorization status: \(status.rawValue)")
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            // Request when-in-use authorization (or always, based on your app's needs)
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location access is restricted.")
        case .denied:
            print("User has denied location permissions.")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location access granted.")
        @unknown default:
            print("Unknown authorization status")
        }
    }
    
    // CLLocationManagerDelegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
