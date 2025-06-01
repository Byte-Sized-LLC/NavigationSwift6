//
//  GenericPersistanceService.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 6/1/25.
//

final class GenericPersistenceService<T: Codable>: @unchecked Sendable {
    private let key: String
    private let storageType: PersistenceStorageType
    private let persistence: any LocalPersistenceProtocol
    
    init(key: String, storageType: PersistenceStorageType = .userDefaults) {
        self.key = key
        self.storageType = storageType
        
        switch storageType {
        case .userDefaults:
            self.persistence = UserDefaultsPersistence()
        case .keychain:
            self.persistence = KeychainPersistence()
        case .swiftData:
            // SwiftData requires special handling, so we'll use UserDefaults as fallback
            self.persistence = UserDefaultsPersistence()
        }
    }
    
    func save(_ object: T) async throws {
        try await persistence.save(object, forKey: key)
    }
    
    func load() async throws -> T? {
        try await persistence.load(T.self, forKey: key)
    }
    
    func delete() async throws {
        try await persistence.delete(forKey: key)
    }
    
    func exists() async -> Bool {
        await persistence.exists(forKey: key)
    }
}
