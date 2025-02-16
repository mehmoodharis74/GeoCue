//
//  GeoCueApp.swift
//  GeoCue
//
//  Created by Haris  on 14/02/2025.
//

import SwiftUI
import Factory
import Combine

@main
struct GeoCueApp: App {
    var notificationManager : NotificationManager = Container.shared.notificationManager()
    var locationManager: UserLocationManager = Container.shared.locationManager()
    
    init(){
        notificationManager.requestAuthorization()
        locationManager.checkLocationAuthorization()
    }
    var body: some Scene {
        WindowGroup {
            MapScreen()
        }
    }
}
