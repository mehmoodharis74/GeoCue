//
//  localLocationRepositoryImp.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

struct LocalLocationRepositoryImpl: LocalLocationRepository {
    private let localDataSource: LocalLocationDataSource

    init(localDataSource: LocalLocationDataSource) {
        self.localDataSource = localDataSource
    }

    func getSavedLocations() throws -> [Location] {
        return try localDataSource.fetchSavedLocations()
    }
    
    func saveLocation(_ location: Location) throws {
        try localDataSource.saveLocation(location)
    }
    
    func updateLocationIsActive(id: String, isActive: Bool) throws {
        try localDataSource.updateLocationIsActive(id: id, isActive: isActive)
    }
}
