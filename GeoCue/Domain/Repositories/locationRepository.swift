//
//  locationRepository.swift
//  GeoCue
//
//  Created by Haris  on 14/02/2025.
//

// domain/repositories/LocationRepository.swift

import Combine

public protocol LocationRepository {
    func fetchLocations(entity: LocationRequestEntity) -> AnyPublisher<[LocationResponseEntity], Error>
}
