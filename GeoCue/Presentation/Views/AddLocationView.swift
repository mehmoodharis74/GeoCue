//
//  AddLocationView.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

import SwiftUI
import MapKit
import Factory

struct AddLocationView: View {
    @Environment(\.dismiss) private var dismiss
    let location: LocationResponseEntity?
    let radius: Double
    // Use the view model from your DI container.
    @StateObject private var viewModel = Container.shared.locationViewModel()
    
    @State private var note: String = ""
    @State private var isActive: Bool = false
    
    init(location: LocationResponseEntity, radius: Double) {
        self.location = location
        self.radius = radius
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Location Details")) {
                    HStack {
                        Text("Name:")
                        Spacer()
                        Text(location?.name ?? "N/A")
                    }
                    HStack {
                        Text("Latitude:")
                        Spacer()
                        Text(String(format: "%.6f", location?.latitude ?? 0))
                    }
                    HStack {
                        Text("Longitude:")
                        Spacer()
                        Text(String(format: "%.6f", location?.longitude ?? 0))
                    }
                    HStack {
                        Text("Radius:")
                        Spacer()
                        Text("\(Int(radius)) m")
                    }
                    HStack {
                        Text("Active")
                        Spacer()
                        Toggle("", isOn: $isActive).labelsHidden()
                    }
                }
                Section(header: Text("Enter your note")) {
                    TextEditor(text: $note)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add Location")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Create a new Location model.
                        let newLocation = Location(
                            id: UUID().uuidString,
                            name: location?.name ?? "Unnamed",
                            latitude: location?.latitude ?? 0,
                            longitude: location?.longitude ?? 0,
                            category: location?.category ?? "",
                            radius: radius,
                            note: note,
                            isActive: isActive
                        )
                        
                        // Use the view model's save method instead of calling DataController.
                        viewModel.saveLocation(newLocation) { success in
                            if success {
                                dismiss()
                            } else {
                                print("Failed to save location: \(viewModel.errorMessage ?? "Unknown error")")
                            }
                        }
                    }
                }
            }
        }
    }
}
