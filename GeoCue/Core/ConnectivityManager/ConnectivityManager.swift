//
//  ConnectivityManager.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

import Network
import Foundation
import Combine
import Network
import Foundation
import Combine

final class ConnectivityManager: ObservableObject {
    static let shared = ConnectivityManager()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "ConnectivityMonitorQueue")
    
    @Published var isConnected: Bool = true
    @Published var isRetrying: Bool = false

    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = (path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)
    }
    
    func retryConnectionCheck() {
        isRetrying = true
        guard let url = URL(string: "https://www.google.com") else {
            DispatchQueue.main.async {
                self.isConnected = false
                self.isRetrying = false
            }
            return
        }
        URLSession.shared.dataTask(with: url) { (_, response, _) in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    self.isConnected = true
                } else {
                    self.isConnected = false
                }
                self.isRetrying = false
            }
        }.resume()
    }
}
