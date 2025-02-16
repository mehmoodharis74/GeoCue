//
//  MapViewModel.swift
//  GeoCue
//
//  Created by Haris  on 14/02/2025.
//

import Foundation
import Combine
import MapKit
import Factory

class LocationViewModel: ObservableObject {
    private let fetchLocationsUseCase: FetchLocationsUseCase
    private let fetchSavedLocationsUseCase: FetchSavedLocationsUseCase
    private let saveLocationUseCase: SaveLocationUseCase
    private let updateLocationIsActiveUseCase: UpdateLocationIsActiveUseCase
    private var cancellables = Set<AnyCancellable>()
    
    @Published var locations: [LocationResponseEntity] = []
    @Published var savedLocations: [Location] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false

    init(fetchLocationsUseCase: FetchLocationsUseCase,
         fetchSavedLocationsUseCase: FetchSavedLocationsUseCase,
         saveLocationUseCase: SaveLocationUseCase,
         updateLocationIsActiveUseCase: UpdateLocationIsActiveUseCase) {
        self.fetchLocationsUseCase = fetchLocationsUseCase
        self.fetchSavedLocationsUseCase = fetchSavedLocationsUseCase
        self.saveLocationUseCase = saveLocationUseCase
        self.updateLocationIsActiveUseCase = updateLocationIsActiveUseCase
    }

    func fetchRemoteLocations() {
        isLoading = true
        errorMessage = nil
        
        fetchLocationsUseCase.execute(entity: LocationRequestEntity())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] locations in
                self?.locations = locations
            })
            .store(in: &cancellables)
    }
    
    func fetchSavedLocations() {
        isLoading = true
        fetchSavedLocationsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] locations in
                self?.savedLocations = locations
            })
            .store(in: &cancellables)
    }
    
    func saveLocation(_ location: Location, completion: @escaping (Bool) -> Void) {
        
        isLoading = true
        saveLocationUseCase.execute(location: location)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    completion(false)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.fetchSavedLocations()
                completion(true)
            }
            .store(in: &cancellables)
    }
    
    func updateLocationIsActive(id: String, isActive: Bool, completion: @escaping (Bool) -> Void) {
        isLoading = true
        updateLocationIsActiveUseCase.execute(id: id, isActive: isActive)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    completion(false)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.fetchSavedLocations()
                completion(true)
            }
            .store(in: &cancellables)
    }
}
