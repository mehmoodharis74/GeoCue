//
//  FakeUseCases.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

// File: GeoCueTests/FakeUseCases.swift
import Foundation
import Combine
@testable import GeoCue

final class FakeFetchLocationsUseCase: FetchLocationsUseCaseProtocol {
    let result: Result<[LocationResponseEntity], Error>
    
    init(result: Result<[LocationResponseEntity], Error>) {
        self.result = result
    }
    
    func execute(entity: LocationRequestEntity) -> AnyPublisher<[LocationResponseEntity], Error> {
        return result.publisher.eraseToAnyPublisher()
    }
}

final class FakeFetchSavedLocationsUseCase: FetchSavedLocationsUseCaseProtocol {
    let result: Result<[Location], Error>
    
    init(result: Result<[Location], Error>) {
        self.result = result
    }
    
    func execute() -> AnyPublisher<[Location], Error> {
        return result.publisher.eraseToAnyPublisher()
    }
}

final class FakeSaveLocationUseCase: SaveLocationUseCaseProtocol {
    let result: Result<Void, Error>
    
    init(result: Result<Void, Error>) {
        self.result = result
    }
    
    func execute(location: Location) -> AnyPublisher<Void, Error> {
        return result.publisher.eraseToAnyPublisher()
    }
}

final class FakeUpdateLocationIsActiveUseCase: UpdateLocationIsActiveUseCaseProtocol {
    let result: Result<Void, Error>
    
    init(result: Result<Void, Error>) {
        self.result = result
    }
    
    func execute(id: String, isActive: Bool) -> AnyPublisher<Void, Error> {
        return result.publisher.eraseToAnyPublisher()
    }
}
