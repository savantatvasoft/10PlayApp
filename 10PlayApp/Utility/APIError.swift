//
//  APIError.swift
//  10PlayApp
//
//  Created by savan soni on 06/04/26.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case unknown

    var errorMessage: String {
        switch self {
        case .invalidURL:
            return "There is an issue with the connection path."
        case .noData:
            return "The server returned no information."
        case .decodingError:
            return "We had trouble reading the data from the server."
        case .serverError(let code):
            return "The server is having trouble (Error \(code))."
        case .unknown:
            return "An unexpected error occurred. Please try again."
        }
    }
}


extension Error {
    var localizedUserMessage: String {
        if let apiError = self as? APIError {
            return apiError.errorMessage
        }
        return self.localizedDescription
    }
}
