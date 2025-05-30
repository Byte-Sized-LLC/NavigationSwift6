//
//  LocalPersistenceService.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/30/25.
//

import Foundation

final class LocalPersistenceService: LocalPersistenceProtocol, @unchecked Sendable {
    private let persistence: any LocalPersistenceProtocol
    
    init(storageType: PersistenceStorageType = .userDefaults) {
        switch storageType {
        case .userDefaults:
            self.persistence = UserDefaultsPersistence()
        case .keychain:
            self.persistence = KeychainPersistence()
        }
    }
    
    func save<T: Codable>(_ value: T, forKey key: String) async throws {
        try await persistence.save(value, forKey: key)
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) async throws -> T? {
        try await persistence.load(type, forKey: key)
    }
    
    func remove(forKey key: String) async throws {
        try await persistence.remove(forKey: key)
    }
    
    func exists(forKey key: String) async -> Bool {
        await persistence.exists(forKey: key)
    }
}
