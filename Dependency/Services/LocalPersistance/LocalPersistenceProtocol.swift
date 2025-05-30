//
//  LocalPersistenceProtocol.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/30/25.
//

import Foundation

// MARK: - Storage Type
enum PersistenceStorageType: Sendable {
    case userDefaults
    case keychain
}

// MARK: - Persistence Protocol
protocol LocalPersistenceProtocol: Sendable {
    func save<T: Codable>(_ value: T, forKey key: String) async throws
    func load<T: Codable>(_ type: T.Type, forKey key: String) async throws -> T?
    func remove(forKey key: String) async throws
    func exists(forKey key: String) async -> Bool
}

// MARK: - Persistence Errors
enum PersistenceError: Error, LocalizedError {
    case encodingFailed
    case decodingFailed
    case keychainError(OSStatus)
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return "Failed to encode data"
        case .decodingFailed:
            return "Failed to decode data"
        case .keychainError(let status):
            return "Keychain error: \(status)"
        case .notFound:
            return "Data not found"
        }
    }
}
