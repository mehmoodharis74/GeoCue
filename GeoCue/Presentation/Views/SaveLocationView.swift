//
//  SaveLocationView.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

import SwiftUI

struct SavedLocationsView: View {
    // We'll load saved locations from persistent storage using DataController.
    @State private var savedLocations: [Location] = []
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List(savedLocations, id: \.id) { location in
                SavedLocationRow(location: location)
            }
            .navigationTitle("Saved Locations")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadLocations()
            }
        }
    }
    
    private func loadLocations() {
        do {
            // Create a DataController instance and fetch saved locations.
            let controller = DataController()
            savedLocations = try controller.fetchLocations()
        } catch {
            print("Error loading saved locations: \(error)")
        }
    }
}

private struct SavedLocationRow: View {
    let location: Location
    @State private var isActive: Bool
    private let dataController = DataController()
    
    init(location: Location) {
        self.location = location
        _isActive = State(initialValue: location.isActive)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Top row: Name and Active toggle.
            HStack {
                Text(location.name)
                    .font(.headline)
                Spacer()
                Toggle("Active", isOn: $isActive)
                    .labelsHidden()
                    .onChange(of: isActive) {_ , newValue in
                        do {
                            try dataController.updateLocationIsActive(id: location.id, isActive: newValue)
                        } catch {
                            print("Error updating location: \(error)")
                        }
                    }
            }
            Text(String(format: "%.6f", location.latitude))
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(String(format: "%.6f", location.longitude))
                .font(.subheadline)
                .foregroundColor(.secondary)
            // Below: Radius and note.
            Text("Radius: \(Int(location.radius)) m")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Note: \(location.note)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 5)
    }
}
