//
//  locationResponseEntity.swift
//  GeoCue
//
//  Created by Haris  on 14/02/2025.
//

// LocationResponseEntity.swift
import MapKit

public struct LocationResponseEntity: BaseEntity, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let latitude: Double
    public let longitude: Double
    public let category: String
    
}
