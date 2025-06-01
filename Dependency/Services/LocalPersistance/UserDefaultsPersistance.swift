//
//  UserDefaultsPersistence.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/30/25.
//

import Foundation

actor UserDefaultsPersistence: LocalPersistenceProtocol {
    private let userDefaults = UserDefaults.standard
    
    func save<T: Codable>(_ object: T, forKey key: String) async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        userDefaults.set(data, forKey: key)
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) async throws -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
    func delete(forKey key: String) async throws {
        userDefaults.removeObject(forKey: key)
    }
    
    func exists(forKey key: String) async -> Bool {
        userDefaults.object(forKey: key) != nil
    }
}
