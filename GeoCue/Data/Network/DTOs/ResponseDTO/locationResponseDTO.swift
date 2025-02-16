//
//  locationResponseDTO.swift
//  GeoCue
//
//  Created by Haris  on 14/02/2025.
//

// LocationResponseDTO.swift
public struct LocationResponseDTO: BaseDTO {
    public let id: String
    public let name: String
    public let lat: Double
    public let lon: Double
    public let category: String
}
