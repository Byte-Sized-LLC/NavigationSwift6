//
//  ProfileViewModel.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

@MainActor
@Observable
final class ProfileViewModel: ViewModel {
    let store: ProfileStore
    private(set) var viewState = ViewState()
    
    struct ViewState {
        var user: User?
        var isLoading = false
        var error: String?
        var hasUnsavedChanges = false
    }
    
    required init(store: ProfileStore) {
        self.store = store
        Task {
            await observeState()
        }
    }
    
    private func observeState() async {
        for await _ in Timer.publish(every: 0.1, on: .main, in: .common).autoconnect().values {
            let state = await store.getState()
            viewState.user = state.user
            viewState.isLoading = state.isLoading
            viewState.error = state.error
            viewState.hasUnsavedChanges = state.hasUnsavedChanges
        }
    }
    
    func loadUser() {
        Task {
            await store.dispatch(.loadUser)
        }
    }
    
    func updateProfile(_ profile: UserProfile) {
        Task {
            await store.dispatch(.updateProfile(profile))
        }
    }
}
