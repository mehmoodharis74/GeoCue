//
//  LocationViewModelTests.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//


import XCTest
import Combine
@testable import GeoCue

class LocationViewModelTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = []
    
    // 1. Test successful remote locations fetching
    func testFetchRemoteLocationsSuccess() {
        let dummyLocation = LocationResponseEntity(id: "1",
                                                     name: "Dummy Location",
                                                     latitude: 1.0,
                                                     longitude: 1.0,
                                                     category: "dummy")
        let fakeFetchUseCase = FakeFetchLocationsUseCase(result: .success([dummyLocation]))
        let fakeFetchSavedUseCase = FakeFetchSavedLocationsUseCase(result: .success([]))
        let fakeSaveUseCase = FakeSaveLocationUseCase(result: .success(()))
        let fakeUpdateUseCase = FakeUpdateLocationIsActiveUseCase(result: .success(()))
        
        let viewModel = LocationViewModel(fetchLocationsUseCase: fakeFetchUseCase,
                                          fetchSavedLocationsUseCase: fakeFetchSavedUseCase,
                                          saveLocationUseCase: fakeSaveUseCase,
                                          updateLocationIsActiveUseCase: fakeUpdateUseCase)
        let expectation = XCTestExpectation(description: "Fetch remote locations success")
        
        viewModel.$locations
            .dropFirst()
            .sink { locations in
                if locations.count == 1 && locations.first?.name == "Dummy Location" {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchRemoteLocations()
        wait(for: [expectation], timeout: 1.0)
    }
    
    // 2. Test remote locations fetching failure
    func testFetchRemoteLocationsFailure() {
        let error = NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Fetch failed"])
        let fakeFetchUseCase = FakeFetchLocationsUseCase(result: .failure(error))
        let fakeFetchSavedUseCase = FakeFetchSavedLocationsUseCase(result: .success([]))
        let fakeSaveUseCase = FakeSaveLocationUseCase(result: .success(()))
        let fakeUpdateUseCase = FakeUpdateLocationIsActiveUseCase(result: .success(()))
        
        let viewModel = LocationViewModel(fetchLocationsUseCase: fakeFetchUseCase,
                                          fetchSavedLocationsUseCase: fakeFetchSavedUseCase,
                                          saveLocationUseCase: fakeSaveUseCase,
                                          updateLocationIsActiveUseCase: fakeUpdateUseCase)
        let expectation = XCTestExpectation(description: "Fetch remote locations failure")
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                if let errorMessage = errorMessage, errorMessage == "Fetch failed" {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchRemoteLocations()
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.locations.count, 0)
    }
    
    // 3. Test successful saved locations fetching
    func testFetchSavedLocationsSuccess() {
        let dummySavedLocation = Location(id: "1",
                                          name: "Saved Location",
                                          latitude: 1.0,
                                          longitude: 1.0,
                                          category: "test",
                                          radius: 50.0,
                                          note: "Note",
                                          isActive: true)
        let fakeFetchSavedUseCase = FakeFetchSavedLocationsUseCase(result: .success([dummySavedLocation]))
        let fakeFetchUseCase = FakeFetchLocationsUseCase(result: .success([]))
        let fakeSaveUseCase = FakeSaveLocationUseCase(result: .success(()))
        let fakeUpdateUseCase = FakeUpdateLocationIsActiveUseCase(result: .success(()))
        
        let viewModel = LocationViewModel(fetchLocationsUseCase: fakeFetchUseCase,
                                          fetchSavedLocationsUseCase: fakeFetchSavedUseCase,
                                          saveLocationUseCase: fakeSaveUseCase,
                                          updateLocationIsActiveUseCase: fakeUpdateUseCase)
            
        let expectation = XCTestExpectation(description: "Fetch saved locations success")
        
        viewModel.$savedLocations
            .dropFirst()
            .sink { locations in
                if locations.count == 1 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        viewModel.fetchSavedLocations()
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.savedLocations.first?.name, "Saved Location")
    }
    
    // 4. Test successful saveLocation call
    func testSaveLocationSuccess() {
        let dummyLocation = Location(id: "1",
                                     name: "New Location",
                                     latitude: 2.0,
                                     longitude: 2.0,
                                     category: "test",
                                     radius: 75.0,
                                     note: "New note",
                                     isActive: false)
        
        let fakeSaveUseCase = FakeSaveLocationUseCase(result: .success(()))
        let fakeFetchSavedUseCase = FakeFetchSavedLocationsUseCase(result: .success([dummyLocation]))
        let fakeFetchUseCase = FakeFetchLocationsUseCase(result: .success([]))
        let fakeUpdateUseCase = FakeUpdateLocationIsActiveUseCase(result: .success(()))
        
        let viewModel = LocationViewModel(fetchLocationsUseCase: fakeFetchUseCase,
                                          fetchSavedLocationsUseCase: fakeFetchSavedUseCase,
                                          saveLocationUseCase: fakeSaveUseCase,
                                          updateLocationIsActiveUseCase: fakeUpdateUseCase)
        
        let saveExpectation = XCTestExpectation(description: "Save location completed")
        let fetchExpectation = XCTestExpectation(description: "Saved locations updated")
        
        viewModel.$savedLocations
            .dropFirst() // Skip initial value
            .sink { locations in
                if locations.count == 1 && locations.first?.name == "New Location" {
                    fetchExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.saveLocation(dummyLocation) { success in
            XCTAssertTrue(success)
            saveExpectation.fulfill()
        }
        
        wait(for: [saveExpectation, fetchExpectation], timeout: 1.0)
        XCTAssertEqual(viewModel.savedLocations.count, 1)
        XCTAssertEqual(viewModel.savedLocations.first?.name, "New Location")
    }
    
    // 5. Test saveLocation failure case
    func testSaveLocationFailure() {
        let dummyLocation = Location(id: "1",
                                     name: "Fail Location",
                                     latitude: 3.0,
                                     longitude: 3.0,
                                     category: "test",
                                     radius: 80.0,
                                     note: "Fail note",
                                     isActive: false)
        let error = NSError(domain: "Test", code: 3, userInfo: [NSLocalizedDescriptionKey: "Save failed"])
        let fakeSaveUseCase = FakeSaveLocationUseCase(result: .failure(error))
        let fakeFetchSavedUseCase = FakeFetchSavedLocationsUseCase(result: .success([]))
        let fakeFetchUseCase = FakeFetchLocationsUseCase(result: .success([]))
        let fakeUpdateUseCase = FakeUpdateLocationIsActiveUseCase(result: .success(()))
        
        let viewModel = LocationViewModel(fetchLocationsUseCase: fakeFetchUseCase,
                                          fetchSavedLocationsUseCase: fakeFetchSavedUseCase,
                                          saveLocationUseCase: fakeSaveUseCase,
                                          updateLocationIsActiveUseCase: fakeUpdateUseCase)
        
        let expectation = XCTestExpectation(description: "Save location failure")
        viewModel.saveLocation(dummyLocation) { success in
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.savedLocations.count, 0)
        XCTAssertEqual(viewModel.errorMessage, "Save failed")
    }
    
    // 6. Test successful updateLocationIsActive call
    func testUpdateLocationIsActiveSuccess() {
        let updatedLocation = Location(id: "1",
                                       name: "Location",
                                       latitude: 4.0,
                                       longitude: 4.0,
                                       category: "test",
                                       radius: 65.0,
                                       note: "Note",
                                       isActive: true)
        
        let fakeUpdateUseCase = FakeUpdateLocationIsActiveUseCase(result: .success(()))
        let fakeFetchSavedUseCase = FakeFetchSavedLocationsUseCase(result: .success([updatedLocation]))
        let fakeFetchUseCase = FakeFetchLocationsUseCase(result: .success([]))
        let fakeSaveUseCase = FakeSaveLocationUseCase(result: .success(()))
        
        let viewModel = LocationViewModel(fetchLocationsUseCase: fakeFetchUseCase,
                                          fetchSavedLocationsUseCase: fakeFetchSavedUseCase,
                                          saveLocationUseCase: fakeSaveUseCase,
                                          updateLocationIsActiveUseCase: fakeUpdateUseCase)
        
        // Expectation for the update completion
        let updateExpectation = XCTestExpectation(description: "Update location is active completed")
        
        // Subscribe to published savedLocations
        let fetchExpectation = XCTestExpectation(description: "Saved locations updated")
        viewModel.$savedLocations
            .dropFirst() // Skip any initial empty value
            .sink { locations in
                if locations.count == 1 && (locations.first?.isActive ?? false) {
                    fetchExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.updateLocationIsActive(id: "1", isActive: true) { success in
            XCTAssertTrue(success)
            updateExpectation.fulfill()
        }
        
        wait(for: [updateExpectation, fetchExpectation], timeout: 1.0)
        XCTAssertEqual(viewModel.savedLocations.count, 1)
        XCTAssertTrue(viewModel.savedLocations.first?.isActive ?? false)
    }
    
    // 7. Test updateLocationIsActive failure case
    func testUpdateLocationIsActiveFailure() {
        let error = NSError(domain: "Test", code: 4, userInfo: [NSLocalizedDescriptionKey: "Update failed"])
        let fakeUpdateUseCase = FakeUpdateLocationIsActiveUseCase(result: .failure(error))
        let fakeFetchSavedUseCase = FakeFetchSavedLocationsUseCase(result: .success([]))
        let fakeFetchUseCase = FakeFetchLocationsUseCase(result: .success([]))
        let fakeSaveUseCase = FakeSaveLocationUseCase(result: .success(()))
        
        let viewModel = LocationViewModel(fetchLocationsUseCase: fakeFetchUseCase,
                                          fetchSavedLocationsUseCase: fakeFetchSavedUseCase,
                                          saveLocationUseCase: fakeSaveUseCase,
                                          updateLocationIsActiveUseCase: fakeUpdateUseCase)
            
        let expectation = XCTestExpectation(description: "Update location is active failure")
        viewModel.updateLocationIsActive(id: "1", isActive: true) { success in
            XCTAssertFalse(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.errorMessage, "Update failed")
    }
}
