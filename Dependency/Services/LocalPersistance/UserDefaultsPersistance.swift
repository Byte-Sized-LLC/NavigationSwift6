//
//  UserDefaultsPersistence.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/30/25.
//

import Foundation

actor UserDefaultsPersistence: LocalPersistenceProtocol {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func save<T: Codable>(_ value: T, forKey key: String) async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        userDefaults.set(data, forKey: key)
        userDefaults.synchronize()
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) async throws -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
    func remove(forKey key: String) async throws {
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }
    
    func exists(forKey key: String) async -> Bool {
        userDefaults.object(forKey: key) != nil
    }
}
