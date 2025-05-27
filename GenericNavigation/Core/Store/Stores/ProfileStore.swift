//
//  ProfileStore.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

actor ProfileStore: Store {
    private var state: ProfileState
    private let dependencies: AppDependencies
    private var continuation: AsyncStream<ProfileState>.Continuation?

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        self.state = ProfileState()
    }
    
    struct ProfileState: Sendable {
        var user: User?
        var isLoading = false
        var error: String?
        var hasUnsavedChanges = false
    }
    
    enum ProfileAction: Sendable {
        case loadUser
        case userLoaded(User)
        case loadFailed(String)
        case updateProfile(UserProfile)
        case profileUpdated
        case setUnsavedChanges(Bool)
    }
    
    var stateStream: AsyncStream<ProfileState> {
        AsyncStream { continuation in
            self.continuation = continuation
            continuation.yield(state)
        }
    }
    
    func getState() -> ProfileState {
        state
    }
    
    func dispatch(_ action: ProfileAction) async {
        switch action {
        case .loadUser:
            state.isLoading = true
            do {
                let user = try await dependencies.userService.fetchCurrentUser()
                await dispatch(.userLoaded(user))
            } catch {
                await dispatch(.loadFailed(error.localizedDescription))
            }
            
        case .userLoaded(let user):
            state.user = user
            state.isLoading = false
            
        case .loadFailed(let error):
            state.error = error
            state.isLoading = false
            
        case .updateProfile(let profile):
            do {
                try await dependencies.userService.updateProfile(profile)
                await dispatch(.profileUpdated)
            } catch {
                await dispatch(.loadFailed(error.localizedDescription))
            }
            
        case .profileUpdated:
            state.hasUnsavedChanges = false
            
        case .setUnsavedChanges(let hasChanges):
            state.hasUnsavedChanges = hasChanges
        }
    }
}
