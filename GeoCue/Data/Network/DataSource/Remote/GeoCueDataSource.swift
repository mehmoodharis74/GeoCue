//
//  GeoCueDataSource.swift
//  GeoCue
//
//  Created by Haris  on 14/02/2025.
//

// data/network/datasource/LocationDataSource.swift

import Foundation
import Combine
import Alamofire


public protocol LocationDataSource {
    func fetchLocations(entity: LocationRequestEntity) -> AnyPublisher<[LocationResponseEntity], Error>
}


public final class RemoteLocationDataSource: LocationDataSource {
    private let apiClient: APIClient
    private let baseURL: String
    
    public init(apiClient: APIClient, baseURL: String) {
        self.apiClient = apiClient
        self.baseURL = baseURL
    }
    
    public func fetchLocations(entity: LocationRequestEntity) -> AnyPublisher<[LocationResponseEntity], Error> {
        let endpoint = APIEndpoints.fetchLocations
        let requestDTO:LocationRequestDTO = LocationMapper.toDTO(from: entity)
        let headers: HTTPHeaders = ["Accept": "application/json"]
        
        guard let url = URL(string: baseURL + endpoint.path) else {
            return Fail(error: NSError(domain: "Invalid URL", code: 0)).eraseToAnyPublisher()
        }
        
        return apiClient.get(url: url, headers: headers)
            .map { (responseDTOs: [LocationResponseDTO]) in
                responseDTOs.map { dto in
                    LocationMapper.toEntity(from: dto)
                }
            }
            .eraseToAnyPublisher()
    }
}
