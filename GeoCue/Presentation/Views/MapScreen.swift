//
//  MapScreen.swift
//  GeoCue
//
//  Created by Haris  on 14/02/2025.
//

import Combine
import Factory
import MapKit
import SwiftUI

struct MapScreen: View {
    @StateObject var viewModel: LocationViewModel = Container.shared.locationViewModel()
    @StateObject private var userLocationManager = Container.shared.locationManager()
    private var dataController = Container.shared.dataController()
    @StateObject private var connectivityManager = ConnectivityManager.shared


    // Use a binding for the camera position so updates animate the map.
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var selectedLocation: LocationResponseEntity? = nil
    @State private var radius: Double = 100  // Default geofence radius in meters
    @State private var showAnnotationsSheet: Bool = false
    @State private var showAddLocationSheet: Bool = false
    @State private var showSavedLocationsSheet: Bool = false
    
    var body: some View {
        ZStack {
            // The Map view using a binding for the camera position.
            Map(position: $cameraPosition, interactionModes: [.all]) {
                // Place markers for each fetched location.
                ForEach(viewModel.locations) { location in
                    Annotation(
                        "",
                        coordinate: CLLocationCoordinate2D(
                            latitude: location.latitude,
                            longitude: location.longitude)
                    ) {
                        MarkerView(location: location, isSelected: location == selectedLocation)
                            .onTapGesture {
                                selectedLocation = location
                                withAnimation {
                                    // Center the map on the tapped location with a tight span.
                                    cameraPosition = .region(
                                        MKCoordinateRegion(
                                            center: CLLocationCoordinate2D(
                                                latitude: location.latitude,
                                                longitude: location.longitude),
                                            span: MKCoordinateSpan(
                                                latitudeDelta: 0.01, longitudeDelta: 0.01)
                                        ))
                                }
                            }
                    }
                    .annotationTitles(.hidden)
                }
                ForEach(viewModel.savedLocations, id: \.id) { loc in
                    Marker(
                        "\(loc.name)", systemImage: "figure.wave",
                        coordinate: CLLocationCoordinate2D(
                            latitude: loc.latitude, longitude: loc.longitude)
                    )
                }

                // If a location is selected, show the geofence circle.
                if let selectedLocation = selectedLocation {
                    withAnimation {
                        MapCircle(
                            center: CLLocationCoordinate2D(
                                latitude: selectedLocation.latitude,
                                longitude: selectedLocation.longitude),
                            radius: radius
                        )
                        .foregroundStyle(.blue.opacity(0.5))
                    }

                }
                // Built-in user location annotation.
                UserAnnotation()
            }
            .mapControls {
                // Display the default user location button.
                MapUserLocationButton()
            }
            .mapStyle(.hybrid(elevation: .realistic))
            .onAppear {
                viewModel.fetchRemoteLocations() //fetch locations from api
                viewModel.fetchSavedLocations() //fetch locations from database
                // If no location is selected, center on the first fetched location.
                if let firstLocation = viewModel.locations.first {
                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(
                                latitude: firstLocation.latitude,
                                longitude: firstLocation.longitude),
                            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                        ))
                }
                if let userLocation = userLocationManager.location {
                    print(
                        "User's Current Location on Appear: Latitude = \(userLocation.coordinate.latitude), Longitude = \(userLocation.coordinate.longitude)"
                    )
                } else {
                    print("User's location is not available on appear.")
                }
            }
            .safeAreaInset(edge: .bottom) {

                HStack(alignment: .bottom) {

                    if selectedLocation != nil {
                        VStack {
                            // Slider for geofence radius with smooth animation.
                            MapCircleSlider(radius: $radius)
                                .onChange(of: radius) { newRadius, _ in
                                    // Update camera to include the full circle.
                                    if let sel = selectedLocation {
                                        // Approximate: 1 degree ~ 111km; adjust span based on circle diameter.
                                        let spanDelta = (newRadius * 2) / 55500.0
                                        withAnimation(.easeInOut) {
                                            cameraPosition = .region(
                                                MKCoordinateRegion(
                                                    center: CLLocationCoordinate2D(
                                                        latitude: sel.latitude,
                                                        longitude: sel.longitude),
                                                    span: MKCoordinateSpan(
                                                        latitudeDelta: spanDelta,
                                                        longitudeDelta: spanDelta)
                                                ))
                                        }
                                    }
                                }
                                .padding()
                                .transition(.opacity)
                            // HStack with Add Location & Saved Locations buttons.
                            HStack {
                                Button("Clear") {
                                    if selectedLocation != nil {
                                        withAnimation {
                                            selectedLocation = nil
                                            radius = 100
                                        }
                                    }
                                }
                                Spacer()
                                Button("Add Location") {
                                    showAddLocationSheet = true
        
                                }

                            }
                            .padding()

                        }
                    } else {
                        HStack {
                            Button("Show Annotations") {
                                showAnnotationsSheet = true
                            }
                            Spacer()
                            Button("Saved Locations") {

                                showSavedLocationsSheet = true
                            }

                        }
                        .padding()

                    }
                }
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)

            }
        }
        .overlay {
            if !connectivityManager.isConnected {
                NoInternetBannerView(retryAction: {
                    connectivityManager.retryConnectionCheck()
                })
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: connectivityManager.isConnected)
            }
        }
        // Present the half sheet listing all annotations.
        .sheet(isPresented: $showAnnotationsSheet) {
            AnnotationsSheet(locations: viewModel.locations) { selected in
                // Callback: when a location is tapped in the sheet, update the map.
                selectedLocation = selected
                withAnimation {
                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(
                                latitude: selected.latitude, longitude: selected.longitude),
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        ))
                    showAnnotationsSheet = false
                }
            }
            .presentationDetents([.medium, .large])
        }
        .fullScreenCover(isPresented: $showAddLocationSheet) {
            AddLocationView(location: $selectedLocation, radius: radius)
        }
        .sheet(isPresented: $showSavedLocationsSheet) {
            SavedLocationsView()
        }
    }
    
}

// MARK: - AnnotationsSheet

struct AnnotationsSheet: View {
    var locations: [LocationResponseEntity]
    var onSelect: (LocationResponseEntity) -> Void  // Callback when a location is tapped.

    var body: some View {
        NavigationView {
            List(locations) { location in
                Button {
                    onSelect(location)
                } label: {
                    Text(location.name)
                        .foregroundColor(.primary)
                }
            }
            .navigationTitle("Annotations").font(.headline)
        }
    }
}

#Preview {
    MapScreen()
}
