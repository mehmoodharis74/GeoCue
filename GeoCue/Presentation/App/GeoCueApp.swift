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
    @State private var cancellables = Set<AnyCancellable>()


    var body: some Scene {
        WindowGroup {
            // Call the use case
            
            MapScreen()
            
        }
    }
}
