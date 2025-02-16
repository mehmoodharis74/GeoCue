//
//  NetworkError.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

import Foundation
import Alamofire

public enum NetworkError: LocalizedError {
    case noInternet
    case timeout
    case unauthorized
    case serverError(statusCode: Int, message: String?)
    case decodingError(Error)
    case invalidURL
    case underlying(Error)
    case unknown

    public var errorDescription: String? {
        switch self {
        case .noInternet:
            return "No Internet connection."
        case .timeout:
            return "The request timed out."
        case .unauthorized:
            return "Unauthorized request."
        case .serverError(let statusCode, let message):
            return "Server error: \(statusCode). \(message ?? "")"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .invalidURL:
            return "Invalid URL."
        case .underlying(let error):
            return error.localizedDescription
        case .unknown:
            return "An unknown error occurred."
        }
    }
}


extension Error {
    func asNetworkError() -> NetworkError {
        // If it's already a NetworkError, just return it.
        if let networkError = self as? NetworkError {
            return networkError
        }
        
        // Map URLError codes.
        if let urlError = self as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return .noInternet
            case .timedOut:
                return .timeout
            default:
                return .underlying(urlError)
            }
        }
        
        // Map Alamofire errors.
        if let afError = self as? AFError {
            switch afError {
            case .sessionTaskFailed(let error as URLError):
                return error.asNetworkError()
            case .responseValidationFailed(reason: let reason):
                switch reason {
                case .unacceptableStatusCode(let code):
                    // Optionally extract further details from a response if needed.
                    return .serverError(statusCode: code, message: nil)
                default:
                    return .underlying(afError)
                }
            default:
                return .underlying(afError)
            }
        }
        
        return .underlying(self)
    }
}
