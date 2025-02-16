//
//  APIEndPoints.swift
//  GeoCue
//
//  Created by Haris  on 14/02/2025.
//

import Foundation
import Alamofire

public enum APIEndpoints {
    case fetchLocations
    
    public var path:String{
        switch self {
        case .fetchLocations:
            return "/v3/6e3471d6-a6f7-4596-8a59-385e60f5edee"
        }
    }
    
}
