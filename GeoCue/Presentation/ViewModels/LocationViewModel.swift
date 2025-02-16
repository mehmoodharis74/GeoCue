//
//  MapViewModel.swift
//  GeoCue
//
//  Created by Haris  on 14/02/2025.
//

import Foundation
import Combine
import MapKit


class LocationViewModel: ObservableObject {
    private let fetchLocationsUseCase: FetchLocationsUseCase
    private var cancellables = Set<AnyCancellable>()
    
    @Published var locations: [LocationResponseEntity] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    

    init(fetchLocationsUseCase: FetchLocationsUseCase) {
        self.fetchLocationsUseCase = fetchLocationsUseCase
    }

    func fetchLocations() {
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

}
