//
//  SaveLocationView.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

import SwiftUI
import Factory

struct SavedLocationsView: View {
    // We'll load saved locations from persistent storage using DataController.
    @Environment(\.dismiss) private var dismiss
    private let dataController: DataController
    @StateObject private var viewModel: LocationViewModel = Container.shared.locationViewModel()
    
    init(dataController: DataController = Container.shared.dataController()){
        self.dataController = dataController
    }

    var body: some View {
        NavigationView {
            List(viewModel.savedLocations, id: \.id) { location in
                SavedLocationRow(location: location)
            }
            .navigationTitle("Saved Locations").font(.subheadline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                    viewModel.fetchSavedLocations()
            }
        }
    }
}

private struct SavedLocationRow: View {
    let location: Location
    @State private var isActive: Bool
    private let viewModel: LocationViewModel

    init(location: Location, viewModel: LocationViewModel = Container.shared.locationViewModel()) {
            self.location = location
            _isActive = State(initialValue: location.isActive)
            self.viewModel = viewModel
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
                    .onChange(of: isActive) { _, newValue in
                                            viewModel.updateLocationIsActive(id: location.id, isActive: newValue) { success in
                                                if !success {
                                                    print("Error updating location: \(viewModel.errorMessage ?? "Unknown error")")
                                                    // Optionally revert the toggle if update fails.
                                                    isActive = location.isActive
                                                }
                                            }
                                        }
            }
            HStack(){
                Text("Coordinates")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(String(format: "%.6f", location.latitude)), \(String(format: "%.6f", location.longitude))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
            }.frame(maxWidth: .infinity)
            
            Text("Note: \(location.note)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 5)
    }
}
