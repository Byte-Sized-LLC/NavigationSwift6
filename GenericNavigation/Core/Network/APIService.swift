//
//  APIService.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

actor APIService: APIServiceProtocol {
    private let session = URLSession.shared
    private var baseURL: String = ""
    
    func setEnvironment(_ environment: AppEnvironment) {
        baseURL = environment.baseURL
    }
    
    func fetchData<T: Decodable & Sendable>(_ endpoint: String) async throws -> T {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
