//
//  UpdateLocationUseCase.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

import Combine


protocol UpdateLocationIsActiveUseCaseProtocol {
    func execute(id: String, isActive: Bool) -> AnyPublisher<Void, Error>
}

struct UpdateLocationIsActiveUseCase: UpdateLocationIsActiveUseCaseProtocol {
    private let repository: LocalLocationRepository

    init(repository: LocalLocationRepository) {
        self.repository = repository
    }

    func execute(id: String, isActive: Bool) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            do {
                try repository.updateLocationIsActive(id: id, isActive: isActive)
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
