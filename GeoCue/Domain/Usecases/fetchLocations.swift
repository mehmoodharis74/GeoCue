//
//  fetchLocations.swift
//  GeoCue
//
//  Created by Haris  on 14/02/2025.
//

// domain/usecases/FetchLocationsUseCase.swift

import Combine


public final class FetchLocationsUseCase {
    private let repository: LocationRepository
    
    public init(repository: LocationRepository) {
        self.repository = repository
    }
    
    public func execute(entity: LocationRequestEntity) -> AnyPublisher<[LocationResponseEntity], Error> {
        return repository.fetchLocations(entity:entity)
    }
}
