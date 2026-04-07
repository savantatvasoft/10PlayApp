//
//  APIService.swift
//  10PlayApp
//
//  Created by savan soni on 31/03/26.
//

import Foundation

protocol APIServiceProtocol {
    func get<T: Decodable>(endpoint: String) async throws -> T
    func post<T: Decodable, B: Encodable>(endpoint: String, body: B) async throws -> T
    func put<T: Decodable, B: Encodable>(endpoint: String, body: B) async throws -> T
    func request<T: Decodable, B: Encodable>(method: String, endpoint: String, body: B) async throws -> T
}


class APIService: APIServiceProtocol {
    
    static let shared = APIService()
    private init() {}

    func get<T: Decodable>(endpoint: String) async throws -> T {
        let fullURL = APIConfig.baseURL + endpoint
        guard let url = URL(string: fullURL) else { throw APIError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        return try handleResponse(data: data, response: response)
    }

    func post<T: Decodable, B: Encodable>(endpoint: String, body: B) async throws -> T {
        let fullURL = APIConfig.baseURL + endpoint
        guard let url = URL(string: fullURL) else { throw APIError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = KeychainHelper.shared.read(for: .apiKey) {
            request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try JSONEncoder().encode(body)
        let (data, response) = try await URLSession.shared.data(for: request)
        return try handleResponse(data: data, response: response)
    }

    func put<T: Decodable, B: Encodable>(endpoint: String, body: B) async throws -> T {
        let token = KeychainHelper.shared.read(for: .apiKey)
        let fullURL = APIConfig.baseURL + endpoint
        guard let url = URL(string: fullURL) else { throw APIError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = KeychainHelper.shared.read(for: .apiKey) {
            request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try JSONEncoder().encode(body)
        let (data, response) = try await URLSession.shared.data(for: request)
        return try handleResponse(data: data, response: response)
    }
    
    
    func request<T: Decodable, B: Encodable>(method: String, endpoint: String, body: B) async throws -> T {
        let fullURL = APIConfig.baseURL + endpoint
        guard let url = URL(string: fullURL) else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = method // "PUT" or "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = KeychainHelper.shared.read(for: .apiKey) {
            request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        return try handleResponse(data: data, response: response)
    }
    
    
    private func handleResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? 500
            throw APIError.serverError(code)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
