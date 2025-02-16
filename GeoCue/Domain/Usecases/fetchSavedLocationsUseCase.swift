//
//  fetchSavedLocationsUseCase.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

import Combine

struct FetchSavedLocationsUseCase {
    private let repository: LocalLocationRepository

    init(repository: LocalLocationRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[Location], Error> {
        Future<[Location], Error> { promise in
            do {
                let locations = try repository.getSavedLocations()
                promise(.success(locations))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
