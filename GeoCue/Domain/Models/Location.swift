//
//  Location.swift
//  GeoCue
//
//  Created by Haris  on 14/02/2025.
//


// domain/models/Location.swift
import Foundation

public struct Location: Identifiable {
    public let id: String
    public let name: String
    public let latitude: Double
    public let longitude: Double
    public let category: String
    public let radius: Double
    public let note: String
    public let isActive: Bool
    
    public init(id: String, name: String, latitude: Double, longitude: Double, category: String, radius: Double, note: String, isActive: Bool = false) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.category = category
        self.radius = radius
        self.note = note
        self.isActive = isActive
    }
}
