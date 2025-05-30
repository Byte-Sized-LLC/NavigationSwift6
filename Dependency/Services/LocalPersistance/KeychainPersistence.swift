//
//  KeychainPersistence.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/30/25.
//

import Foundation
import Security

actor KeychainPersistence: LocalPersistenceProtocol {
    private let service: String
    
    init(service: String = Bundle.main.bundleIdentifier ?? "GenericNavigation") {
        self.service = service
    }
    
    func save<T: Codable>(_ value: T, forKey key: String) async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        
        // Remove existing item if it exists
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(deleteQuery as CFDictionary)
        
        // Add new item
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            throw PersistenceError.keychainError(status)
        }
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) async throws -> T? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecItemNotFound {
            return nil
        }
        
        guard status == errSecSuccess,
              let data = result as? Data else {
            throw PersistenceError.keychainError(status)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
    func remove(forKey key: String) async throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw PersistenceError.keychainError(status)
        }
    }
    
    func exists(forKey key: String) async -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
}
