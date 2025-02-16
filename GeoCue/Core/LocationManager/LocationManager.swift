//
//  LocationManager.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

import CoreLocation
import Combine
import Foundation


//// MARK: - UserLocationManager
//
//final class UserLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    @Published var location: CLLocation? = nil
//    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
//    private let locationManager: CLLocationManager
//    
//    override init() {
//        locationManager = CLLocationManager()
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//                    self?.checkLocationServicesEnabled()
//                }
//    }
//    
//    public func checkLocationServicesEnabled() {
//            if CLLocationManager.locationServicesEnabled() {
//                DispatchQueue.main.async {
//                    self.locationManager.startUpdatingLocation()
//                    self.checkLocationAuthorization()
//                }
//            } else {
//                DispatchQueue.main.async {
//                    print("Location services are turned off.")
//                    self.authorizationStatus = .denied
//                }
//            }
//        }
//    
//    private func checkLocationAuthorization() {
//        let status = locationManager.authorizationStatus
//        print("Current authorization status: \(status.rawValue)")
//        authorizationStatus = status
//        
//        switch status {
//        case .notDetermined:
//            print("Requesting location permissions.")
//            locationManager.requestWhenInUseAuthorization()
//        case .restricted:
//            print("Location access is restricted.")
//        case .denied:
//            print("User has denied location permissions.")
//        case .authorizedWhenInUse, .authorizedAlways:
//            print("Location access granted.")
//            locationManager.startUpdatingLocation()
//        @unknown default:
//            print("Unknown authorization status.")
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let newLoc = locations.last else { return }
//        DispatchQueue.main.async {
//            self.location = newLoc
//            print("Current Location: Latitude = \(newLoc.coordinate.latitude), Longitude = \(newLoc.coordinate.longitude)")
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location manager failed with error: \(error.localizedDescription)")
//    }
//    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        print("Authorization status changed.")
//        checkLocationAuthorization()
//    }
//}

import SwiftUI
import CoreLocation
import Factory
import Combine

final class UserLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation? = nil
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    private let locationManager: CLLocationManager
    private let dataController: DataController
    private var cancellables = Set<AnyCancellable>()
    
    // Cache for saved locations fetched via the use case.
    private var savedLocationsCache: [Location] = []
    
    public init(dataController: DataController) {
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.dataController = dataController
        super.init()
    }
    
    func checkLocationAuthorization() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            print("Location restricted")
            
        case .denied:
            print("Location denied")
            
        case .authorizedAlways:
            print("Location authorizedAlways")
            startMonitoringActiveLocations()
            
        case .authorizedWhenInUse:
            print("Location authorized when in use")
            locationManager.requestAlwaysAuthorization()
            
        @unknown default:
            print("Location service disabled")
        }
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    // MARK: - Region Monitoring for Active Locations
    func startMonitoringActiveLocations() {
        Container.shared.fetchSavedLocationsUseCase().execute()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error fetching active locations for monitoring: \(error)")
                }
            } receiveValue: { [weak self] locations in
                guard let self = self else { return }
                // Update the cache with all saved locations from the use case.
                self.savedLocationsCache = locations
                let activeLocations = locations.filter { $0.isActive }
                for loc in activeLocations {
                    let center = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
                    let region = CLCircularRegion(center: center, radius: loc.radius, identifier: loc.id)
                    region.notifyOnEntry = true
                    region.notifyOnExit  = true
                    if !self.locationManager.monitoredRegions.contains(where: { $0.identifier == loc.id }) {
                        self.locationManager.startMonitoring(for: region)
                        print("Started monitoring region for \(loc.name)")
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLoc = locations.last else { return }
        DispatchQueue.main.async {
            self.location = newLoc
            print("Current Location: Latitude = \(newLoc.coordinate.latitude), Longitude = \(newLoc.coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Authorization status changed.")
        checkLocationAuthorization()
    }
    
    // Called when the user enters a monitored region.
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let circularRegion = region as? CLCircularRegion,
              let activeLoc = activeLocation(for: circularRegion.identifier) else { return }
              
        let title = "Inside \(activeLoc.name)"
        let body = activeLoc.note
        NotificationManager.shared.sendNotification(title: title, body: body)
        print("Entered region for \(activeLoc.name)")
    }
    
    // Called when the user exits a monitored region.
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard let circularRegion = region as? CLCircularRegion,
              let activeLoc = activeLocation(for: circularRegion.identifier) else { return }
              
        let title = "Outside \(activeLoc.name)"
        let body = activeLoc.note
        NotificationManager.shared.sendNotification(title: title, body: body)
        print("Exited region for \(activeLoc.name)")
    }
    
    // Updated activeLocation using the cached saved locations from the use case.
    private func activeLocation(for id: String) -> Location? {
        return savedLocationsCache.first { $0.id == id && $0.isActive }
    }
}
