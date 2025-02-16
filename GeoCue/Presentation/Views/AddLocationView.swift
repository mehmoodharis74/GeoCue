//
//  AddLocationView.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

import SwiftUI
import MapKit

struct AddLocationView: View {
    @Environment(\.dismiss) private var dismiss
    let location: LocationResponseEntity?
    let radius: Double
    let dataController: DataController
    @State private var note: String = ""
    @State private var isActive: Bool = false
    
    init(location: LocationResponseEntity, radius: Double, dataController: DataController = DataController()){
        self.dataController = dataController
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
                    HStack{
                        Text("Active")
                        Spacer()
                        Toggle("",isOn: $isActive).labelsHidden()
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
                        
                        do {
                            // Save the location using your DataController.
                            try dataController.saveLocation(newLocation)
                            dismiss()
                        } catch {
                            print("Error saving location: \(error)")
                        }
                    }
                }
            }
        }
    }
}
