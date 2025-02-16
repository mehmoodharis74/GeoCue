//
//  locationMapper.swift
//  GeoCue
//
//  Created by Haris  on 14/02/2025.
//

// data/datamapping/mappers/LocationMapper.swift
import Foundation


public final class LocationMapper {
    public static func toDTO<T: BaseDTO>(from entity: BaseEntity) -> T {
        if let requestEntity = entity as? LocationRequestEntity {
            return LocationRequestDTO(
            ) as! T
        }
        fatalError("Unsupported entity type for DTO conversion")
    }

    public static func toEntity<T: BaseEntity>(from dto: BaseDTO) -> T {
        if let responseDTO = dto as? LocationResponseDTO {
            return LocationResponseEntity(
                id: responseDTO.id,
                name: responseDTO.name,
                latitude: responseDTO.lat,
                longitude: responseDTO.lon,
                category: responseDTO.category
            ) as! T
        }
        fatalError("Unsupported DTO type for entity conversion")
    }
}
