//
//  GeoCueLocatDataSource.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

import Combine
import Foundation
import CoreData

protocol LocalLocationDataSource {
    func fetchSavedLocations() throws -> [Location]
    func saveLocation(_ location: Location) throws
    func updateLocationIsActive(id: String, isActive: Bool) throws
}

struct LocalLocationDataSourceImpl: LocalLocationDataSource {
    private let dataController: DataController

    init(dataController: DataController) {
        self.dataController = dataController
    }

    func fetchSavedLocations() throws -> [Location] {
        let context = dataController.container.viewContext
        let fetchRequest: NSFetchRequest<LocationItem> = LocationItem.fetchRequest()
        let locationEntities = try context.fetch(fetchRequest)
        return locationEntities.map { entity in
            Location(
                id: entity.id ?? "",
                name: entity.name ?? "",
                latitude: entity.latitude,
                longitude: entity.longitude,
                category: entity.category ?? "",
                radius: entity.radius,
                note: entity.note ?? "",
                isActive: entity.isActive
            )
        }
    }
    
    func saveLocation(_ location: Location) throws {
        let context = dataController.container.viewContext
        let locationEntity = LocationItem(context: context)
        locationEntity.id = location.id
        locationEntity.name = location.name
        locationEntity.latitude = location.latitude
        locationEntity.longitude = location.longitude
        locationEntity.category = location.category
        locationEntity.radius = location.radius
        locationEntity.note = location.note
        locationEntity.isActive = location.isActive
        
        try context.save()
    }
    
    func updateLocationIsActive(id: String, isActive: Bool) throws {
        let context = dataController.container.viewContext
        let fetchRequest: NSFetchRequest<LocationItem> = LocationItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let results = try context.fetch(fetchRequest)
        guard let locationEntity = results.first else {
            throw NSError(domain: "LocalLocationDataSource", code: 404, userInfo: [NSLocalizedDescriptionKey: "Location not found"])
        }
        locationEntity.isActive = isActive
        try context.save()
    }
}
