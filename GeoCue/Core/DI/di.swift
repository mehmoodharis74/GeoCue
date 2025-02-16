//
//  di.swift
//  GeoCue
//
//  Created by Haris  on 14/02/2025.
//
import Factory
import Alamofire
import Foundation

extension Container {
    var session: Factory<Session> {
        self {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            return Session(configuration: configuration)
        }.singleton
    }
    //API Client
    var apiClient: Factory<APIClient>{
        self { GeoCueAPIClient(session: self.session())}.singleton
    }
    
    //DataController
    var dataController: Factory<DataController>{
        self { DataController() }.singleton
    }
    
    //Notification Manager
    var notificationManager: Factory<NotificationManager>{
        self { NotificationManager() }.singleton
    }
    //Location Manager
    var locationManager: Factory<UserLocationManager>{
        self { UserLocationManager(dataController: self.dataController(), notificationManager: self.notificationManager())}.singleton
    }
    
    //Data Sources
    var locationDataSource: Factory<LocationDataSource>{
        self { RemoteLocationDataSource(apiClient: self.apiClient(), baseURL: "https://run.mocky.io")}
    
    }
    var localLocationDataSource: Factory<LocalLocationDataSource> {
            self { LocalLocationDataSourceImpl(dataController: self.dataController()) }.singleton
        }
        
        
        
        
    
    //Repositories
    var locationRepository: Factory<LocationRepository>{
        self { locationRepositoryImp(dataSource: self.locationDataSource())}
    }
    var localLocationRepository: Factory<LocalLocationRepository> {
        self { LocalLocationRepositoryImpl(localDataSource: self.localLocationDataSource()) }.singleton
    }
    
    //UseCases
    var fetchLocationUseCase: Factory<FetchLocationsUseCase>{
        self { FetchLocationsUseCase(repository: self.locationRepository())}
    }
    var fetchSavedLocationsUseCase: Factory<FetchSavedLocationsUseCase> {
        self { FetchSavedLocationsUseCase(repository: self.localLocationRepository()) }
    }
    var saveLocationUseCase: Factory<SaveLocationUseCase> {
            self { SaveLocationUseCase(repository: self.localLocationRepository()) }
    }
        
    var updateLocationIsActiveUseCase: Factory<UpdateLocationIsActiveUseCase> {
            self { UpdateLocationIsActiveUseCase(repository: self.localLocationRepository()) }
    }
    
    //ViewModel
    var locationViewModel: Factory<LocationViewModel> {
            self {
                LocationViewModel(
                    fetchLocationsUseCase: self.fetchLocationUseCase(),
                    fetchSavedLocationsUseCase: self.fetchSavedLocationsUseCase(),
                    saveLocationUseCase: self.saveLocationUseCase(),
                    updateLocationIsActiveUseCase: self.updateLocationIsActiveUseCase()
                )
            }.singleton
    }
    
}
