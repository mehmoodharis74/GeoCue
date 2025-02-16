# GeoCue
GeoCue is an iOS app that triggers location-based reminders using geofencing. It notifies you with custom alerts when you enter or exit your favorite places. Built with SwiftUI, MapKit, and Core Data using a clean MVVM architecture.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Tech-Stack](#tech-stack)
- [Architecture](#architecture)
- [Installation](#installation)
- [Usage](#usage)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Overview
GeoCue is a smart geofencing app that lets you create and manage reminders triggered by your location. With a beautifully designed interface built in SwiftUI, GeoCue automatically sends you local notifications when you cross into or out of designated geofenced areas. Whether it’s reminding you to pick up groceries near your favorite store or alerting you when you’re close to a landmark, GeoCue keeps you in the loop—all without manual input.

## Features

- **Interactive Map:** View points of interest with custom annotations on a dynamic map powered by MapKit.  
- **Custom Geofences:** Set up geofences with a customizable radius using an intuitive circular slider.  
- **Local Notifications:** Receive immediate notifications when you enter or exit a geofenced area.  
- **Persistent Reminders:** Save and manage your reminders locally using Core Data—your geofence reminders persist between app launches.  
- **Active State Management:** Toggle geofence reminders as “active” or “inactive” and get notified only for active locations.  
- **Clean Architecture:** Built with a robust MVVM pattern and dependency injection, ensuring scalability and maintainability.  

## Tech-Stack

- **SwiftUI:** For building a modern, declarative UI.  
- **MapKit:** For map rendering and geofencing functionality.  
- **Core Data:** For local data persistence of your geofence reminders.  
- **Combine:** For reactive programming and asynchronous data handling.  
- **MVVM Architecture:** Clean separation of concerns between Views, ViewModels, and Models.  
- **Dependency Injection:** Using a DI container (e.g., Factory) to inject dependencies throughout the app.  

## Architecture

GeoCue follows a clean MVVM architecture:  

### Model  
The `Location` struct holds data for each geofence reminder (id, name, coordinates, category, radius, note, and active state).  

### ViewModel  
`LocationViewModel` manages business logic, including fetching locations from a public API, persisting reminders with Core Data, and handling geofence events.  

### View  
SwiftUI views (e.g., `MapScreen`, `AddLocationView`, and `SavedLocationsView`) render the UI and interact with the ViewModel.  

### Data Layer  
`DataController` manages Core Data stack operations and CRUD functionality.  

### Location & Notification Management  
`UserLocationManager` handles location updates and region monitoring, while `NotificationManager` deals with local notifications.  


## Installation
1. **Clone the Repository:**
   ```bash
   git clone https://github.com/mehmoodharis74/GeoCue.git
   cd GeoCue
   ```
2. **Open in Xcode:**
   - Open the `GeoCue.xcodeproj` or `GeoCue.xcworkspace` file in Xcode.
3. **Build the Project:**
   - Select your simulator or device and, in Xcode, press `Cmd+R` to run the app.


## Usage
Map Screen:
The main screen displays an interactive map with markers for various locations. Tap a marker to set up a geofence. Adjust the radius using the slider, and add new reminders with the “Add Location” button.

Add Location:
Use the Add Location screen to review details of a selected location (name, coordinates, radius) and enter a custom note. Save the reminder to persist it.

Saved Locations:
View all saved geofence reminders in the Saved Locations screen. Toggle their active state to control which reminders trigger notifications.

Notifications:
GeoCue monitors active geofences. When you enter or exit an active region, a local notification will be triggered with the location's name and note.

## Testing
The project uses unit tests to ensure that the view models and persistence layer work as expected.

### ViewModel Tests
- **Asynchronous Updates:**  
  The tests use `XCTestExpectation` to wait for the `@Published` properties to update. For example:
  - `testUpdateLocationIsActiveSuccess`: Subscribes to `savedLocations` using Combine’s `.sink` and waits until the location’s state reflects the update.
  - `testSaveLocationSuccess`: Waits for the asynchronous saving process to complete and verifies that the saved location is updated.

### Core Data Tests
- **Saving and Fetching:**  
  Tests ensure that a new location is correctly saved and that fetching operations return the expected values.
- **Updating Data:**  
  Validates that changes (like toggling `isActive`) are persisted.
### Fake Use Cases
- **Purpose:**  
  Fake implementations (found in `FakeUseCases.swift`) simulate the responses of the real use cases without performing actual network or disk operations.
- **Example:**
  ```swift
  final class FakeFetchLocationsUseCase: FetchLocationsUseCaseProtocol {
      let result: Result<[LocationResponseEntity], Error>
      
      init(result: Result<[LocationResponseEntity], Error>) {
          self.result = result
      }
      
      func execute(entity: LocationRequestEntity) -> AnyPublisher<[LocationResponseEntity], Error> {
          return result.publisher.eraseToAnyPublisher()
      }
  }
  ```

## Contributing
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them.
4. Push to your fork and submit a pull request.
5. Ensure your code adheres to the project’s style guidelines and passes all tests.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact
For questions or support, please contact [mehmoodharis74@gmail.com](mailto:mehmoodharis74@gmail.com).

