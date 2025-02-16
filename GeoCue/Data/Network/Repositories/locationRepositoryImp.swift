//
//  locationRepositoryImp.swift
//  GeoCue
//
//  Created by Haris  on 14/02/2025.
//
import Combine

public struct locationRepositoryImp: LocationRepository{
    private let dataSource: LocationDataSource
    public init(dataSource: LocationDataSource){
        self.dataSource = dataSource
    }
    public func fetchLocations(entity: LocationRequestEntity) -> AnyPublisher<[LocationResponseEntity], any Error> {
        return dataSource.fetchLocations(entity: entity)
    }
    
    
}
