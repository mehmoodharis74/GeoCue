//
//  MapCircleSlider.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

import SwiftUI


// MARK: - MapCircleSlider
struct MapCircleSlider: View {
    @Binding var radius: Double
    
    var body: some View {
        VStack {
            Text("Geofence Radius: \(Int(radius))m")
                .font(.headline)
            Slider(value: $radius, in: 100...1000, step: 100)
                .accentColor(.blue)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.bottom, 20)
    }
}
