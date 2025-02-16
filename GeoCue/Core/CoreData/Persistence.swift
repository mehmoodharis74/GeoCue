//
//  Persistence.swift
//  GeoCue
//
//  Created by Haris  on 14/02/2025.
//

import CoreData

struct DataController {
    
    let container: NSPersistentContainer
    
    public init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GeoCue")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
//    func saveLocation(_ location: Location) throws {
//        let context = container.viewContext
//        let locationEntity = LocationItem(context: context)
//        locationEntity.id = location.id
//        locationEntity.name = location.name
//        locationEntity.latitude = location.latitude
//        locationEntity.longitude = location.longitude
//        locationEntity.category = location.category
//        locationEntity.radius = location.radius
//        locationEntity.note = location.note
//        locationEntity.isActive = location.isActive
//
//        do {
//            try context.save()
//        } catch {
//            throw error
//        }
//    }
    
//    func updateLocationIsActive(id: String, isActive: Bool) throws {
//            let context = container.viewContext
//            let fetchRequest: NSFetchRequest<LocationItem> = LocationItem.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
//            let results = try context.fetch(fetchRequest)
//            if let locationEntity = results.first {
//                locationEntity.isActive = isActive
//                try context.save()
//            }
//        }
    func clearAllLocations() throws {
            let context = container.viewContext
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = LocationItem.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try context.execute(batchDeleteRequest)
            try context.save()
        }
}
