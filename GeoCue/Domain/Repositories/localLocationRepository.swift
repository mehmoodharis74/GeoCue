//
//  localLocationRepository.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

import Foundation

protocol LocalLocationRepository {
    func getSavedLocations() throws -> [Location]
    func saveLocation(_ location: Location) throws
    func updateLocationIsActive(id: String, isActive: Bool) throws
}

