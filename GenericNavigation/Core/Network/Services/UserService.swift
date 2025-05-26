//
//  UserService.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

actor UserService: UserServiceProtocol {
    private let apiService: any APIServiceProtocol
    private var cachedUser: User?
    
    init(apiService: any APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchCurrentUser() async throws -> User {
        if let cached = cachedUser {
            return cached
        }
        
        // Simulate network call
        try await Task.sleep(nanoseconds: 1_000_000_000)
        let user = User(id: "1", name: "Test User", email: "test@example.com")
        cachedUser = user
        return user
    }
    
    func updateProfile(_ profile: UserProfile) async throws {
        // Implementation
        try await Task.sleep(nanoseconds: 500_000_000)
        cachedUser?.profile = profile
    }
}
