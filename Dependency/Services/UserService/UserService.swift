//
//  UserService.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 6/1/25.
//

actor UserService: UserServiceProtocol {
    private let apiService: any APIServiceProtocol
    private let persistenceService: LocalPersistenceService
    private var cachedUser: User?
    
    init(apiService: any APIServiceProtocol, persistenceService: LocalPersistenceService) {
        self.apiService = apiService
        self.persistenceService = persistenceService
    }
    
    func fetchCurrentUser() async throws -> User {
        // First check cache
        if let cached = cachedUser {
            return cached
        }
        
        // Then check persisted profile
        if let profile = try await persistenceService.loadUserProfile() {
            let user = User(id: "1", name: profile.name, email: "cached@example.com", profile: profile)
            cachedUser = user
            return user
        }
        
        // Finally, fetch from API
        try await Task.sleep(nanoseconds: 1_000_000_000)
        let user = User(id: "1", name: "Test User", email: "test@example.com")
        cachedUser = user
        return user
    }
    
    func updateProfile(_ profile: UserProfile) async throws {
        // Save to keychain for secure storage
        try await persistenceService.saveUserProfile(profile)
        
        // Update cache
        cachedUser?.profile = profile
        
        // In real app, also sync with backend
        try await Task.sleep(nanoseconds: 500_000_000)
    }
}
