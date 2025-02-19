//
//  apiClient.swift
//  GeoCue
//
//  Created by Haris  on 14/02/2025.
//

// data/network/apiclient/APIClient.swift

import Foundation
import Alamofire
import Combine

public protocol APIClient {
    func get<T: Decodable> (url: URL, headers: HTTPHeaders?) -> AnyPublisher<T,Error>
  
}


public final class GeoCueAPIClient:APIClient {
    
    public let currentSession: Session
    public init(session: Session) {self.currentSession = session}
    
    
    
    public func get<T: Sendable>(url: URL, headers: HTTPHeaders?) -> AnyPublisher<T, any Error> where T: Decodable {
        guard ConnectivityManager.shared.isConnected else {
                    return Fail(error: NetworkError.noInternet)
                        .eraseToAnyPublisher()
                }
                
        // Create the request
        var request = URLRequest(url: url)
        request.method = .get
        if let headers = headers {
            request.headers = headers
        }
        
        // Use the Alamofire session to perform the request
        return currentSession.request(request)
                    .validate() // Optionally validate the response.
                    .publishDecodable(type: T.self)
                    .value() // Extract the decoded value.
                    .mapError { $0.asNetworkError() }
                    .eraseToAnyPublisher()
    }
}


