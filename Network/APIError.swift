//
//  APIError.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

enum APIError: Error, Sendable {
    case invalidURL
    case decodingError
    case networkError
}
