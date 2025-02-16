//
//  saveLocationUseCase.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

import Combine

struct SaveLocationUseCase {
    private let repository: LocalLocationRepository

    init(repository: LocalLocationRepository) {
        self.repository = repository
    }

    func execute(location: Location) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            do {
                try repository.saveLocation(location)
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
