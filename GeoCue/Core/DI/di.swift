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
        self { UserLocationManager(dataController: self.dataController()) }.singleton
    }
    
    //Data Sources
    var locationDataSource: Factory<LocationDataSource>{
        self { RemoteLocationDataSource(apiClient: self.apiClient(), baseURL: "https://run.mocky.io")} 
    }
    
    //Repositories
    var locationRepository: Factory<LocationRepository>{
        self { locationRepositoryImp(dataSource: self.locationDataSource())}
    }
    
    //UseCases
    var fetchLocationUseCase: Factory<FetchLocationsUseCase>{
        self { FetchLocationsUseCase(repository: self.locationRepository())}
    }
    
    //ViewModel
    var locationViewModel: Factory<LocationViewModel>{
        self { LocationViewModel(fetchLocationsUseCase: self.fetchLocationUseCase())}
    }
    
}
