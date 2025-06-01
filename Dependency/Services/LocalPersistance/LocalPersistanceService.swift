//
//  LocalPersistenceService.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/30/25.
//

import Foundation
import SwiftData

final class LocalPersistenceService: LocalPersistenceProtocol, @unchecked Sendable {
    private let userDefaultsPersistence: UserDefaultsPersistence
    private let keychainPersistence: KeychainPersistence
    private let swiftDataPersistence: SwiftDataPersistence?
    private let storageType: PersistenceStorageType
    
    init(storageType: PersistenceStorageType = .userDefaults) {
        self.storageType = storageType
        self.userDefaultsPersistence = UserDefaultsPersistence()
        self.keychainPersistence = KeychainPersistence()
        
        // Initialize SwiftData with the models we want to persist
        self.swiftDataPersistence = try? SwiftDataPersistence(modelTypes: [Item.self])
    }
    
    // MARK: - LocalPersistenceProtocol Conformance
    func save<T: Codable>(_ object: T, forKey key: String) async throws {
        switch storageType {
        case .userDefaults:
            try await userDefaultsPersistence.save(object, forKey: key)
        case .keychain:
            try await keychainPersistence.save(object, forKey: key)
        case .swiftData:
            // For SwiftData, we need special handling
            if let item = object as? Item {
                try await swiftDataPersistence?.save(item)
            } else if let items = object as? [Item] {
                try await swiftDataPersistence?.save(items)
            } else {
                // Fall back to UserDefaults for non-SwiftData types
                try await userDefaultsPersistence.save(object, forKey: key)
            }
        }
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) async throws -> T? {
        switch storageType {
        case .userDefaults:
            return try await userDefaultsPersistence.load(type, forKey: key)
        case .keychain:
            return try await keychainPersistence.load(type, forKey: key)
        case .swiftData:
            // For SwiftData, we need special handling
            if type == [Item].self {
                let items = try await swiftDataPersistence?.load(Item.self) ?? []
                return items as? T
            } else if type == Item.self {
                let items = try await swiftDataPersistence?.load(Item.self) ?? []
                return items.first as? T
            } else {
                // Fall back to UserDefaults for non-SwiftData types
                return try await userDefaultsPersistence.load(type, forKey: key)
            }
        }
    }
    
    func delete(forKey key: String) async throws {
        switch storageType {
        case .userDefaults:
            try await userDefaultsPersistence.delete(forKey: key)
        case .keychain:
            try await keychainPersistence.delete(forKey: key)
        case .swiftData:
            if key == "items" {
                try await swiftDataPersistence?.deleteAll(Item.self)
            } else {
                try await userDefaultsPersistence.delete(forKey: key)
            }
        }
    }
    
    func exists(forKey key: String) async -> Bool {
        switch storageType {
        case .userDefaults:
            return await userDefaultsPersistence.exists(forKey: key)
        case .keychain:
            return await keychainPersistence.exists(forKey: key)
        case .swiftData:
            if key == "items" {
                guard let count = try? await swiftDataPersistence?.count(Item.self) ?? 0 else { return false }
                return count > 0
            } else {
                return await userDefaultsPersistence.exists(forKey: key)
            }
        }
    }
    
    // MARK: - Convenience Methods with Specific Storage
    func saveOnboardingState(_ state: OnboardingPersistenceModel) async throws {
        try await userDefaultsPersistence.save(state, forKey: "onboarding_state")
    }
    
    func loadOnboardingState() async throws -> OnboardingPersistenceModel? {
        try await userDefaultsPersistence.load(OnboardingPersistenceModel.self, forKey: "onboarding_state")
    }
    
    func saveUserProfile(_ profile: UserProfile) async throws {
        try await keychainPersistence.save(profile, forKey: "user_profile")
    }
    
    func loadUserProfile() async throws -> UserProfile? {
        try await keychainPersistence.load(UserProfile.self, forKey: "user_profile")
    }
    
    func saveItems(_ items: [Item]) async throws {
        guard let swiftData = swiftDataPersistence else {
            throw PersistenceError.notFound
        }
        // Clear existing items first
        try await swiftData.deleteAll(Item.self)
        // Save new items
        try await swiftData.save(items)
    }
    
    func loadItems() async throws -> [Item] {
        guard let swiftData = swiftDataPersistence else {
            return []
        }
        return try await swiftData.load(Item.self)
    }
    
    func saveItem(_ item: Item) async throws {
        guard let swiftData = swiftDataPersistence else {
            throw PersistenceError.notFound
        }
        try await swiftData.save(item)
    }
    
    func deleteItem(_ item: Item) async throws {
        guard let swiftData = swiftDataPersistence else {
            throw PersistenceError.notFound
        }
        try await swiftData.delete(item)
    }
    
    func clearAllData() async throws {
        try await userDefaultsPersistence.delete(forKey: "onboarding_state")
        try await keychainPersistence.delete(forKey: "user_profile")
        try? await swiftDataPersistence?.deleteAll(Item.self)
    }
}
