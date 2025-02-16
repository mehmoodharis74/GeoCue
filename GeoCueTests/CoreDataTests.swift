//
//  CoreDataTests.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

import XCTest
import CoreData
@testable import GeoCue

class CoreDataTests: XCTestCase {
    var dataController: DataController!
    
    override func setUp() {
        super.setUp()
        dataController = DataController(inMemory: true)
    }
    
    override func tearDown() {
        dataController = nil
        super.tearDown()
    }
    
    func testSaveAndFetchLocation() {
        let context = dataController.container.viewContext
        let entityName = "LocationItem"
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            XCTFail("Failed to get LocationItem entity")
            return
        }
        let locationItem = NSManagedObject(entity: entity, insertInto: context)
        locationItem.setValue("1", forKey: "id")
        locationItem.setValue("Test Location", forKey: "name")
        locationItem.setValue(1.0, forKey: "latitude")
        locationItem.setValue(1.0, forKey: "longitude")
        locationItem.setValue(100.0, forKey: "radius")
        locationItem.setValue("Test Note", forKey: "note")
        locationItem.setValue(true, forKey: "isActive")
        
        do {
            try context.save()
        } catch {
            XCTFail("Saving context failed: \(error)")
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        do {
            let results = try context.fetch(fetchRequest)
            XCTAssertEqual(results.count, 1)
            let fetchedLocation = results.first
            XCTAssertEqual(fetchedLocation?.value(forKey: "name") as? String, "Test Location")
        } catch {
            XCTFail("Fetch failed: \(error)")
        }
    }
    
    func testUpdateLocationIsActive() {
        let context = dataController.container.viewContext
        let entityName = "LocationItem"
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            XCTFail("Failed to get LocationItem entity")
            return
        }
        let locationItem = NSManagedObject(entity: entity, insertInto: context)
        locationItem.setValue("2", forKey: "id")
        locationItem.setValue("Test Update", forKey: "name")
        locationItem.setValue(1.0, forKey: "latitude")
        locationItem.setValue(1.0, forKey: "longitude")
        locationItem.setValue(100.0, forKey: "radius")
        locationItem.setValue("Initial Note", forKey: "note")
        locationItem.setValue(false, forKey: "isActive")
        
        do {
            try context.save()
        } catch {
            XCTFail("Saving context failed: \(error)")
        }
        
        // Update the isActive flag to true.
        locationItem.setValue(true, forKey: "isActive")
        do {
            try context.save()
        } catch {
            XCTFail("Saving updated context failed: \(error)")
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", "2")
        do {
            let results = try context.fetch(fetchRequest)
            XCTAssertEqual(results.count, 1)
            let fetchedLocation = results.first
            XCTAssertEqual(fetchedLocation?.value(forKey: "isActive") as? Bool, true)
        } catch {
            XCTFail("Fetch failed: \(error)")
        }
    }
}
