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
    private let navigationManager: NavigationManager
    
    let store: ProfileStore
    private(set) var viewState = ViewState()
    private var stateObservationTask: Task<Void, Never>?
    
    struct ViewState {
        var user: User?
        var isLoading = false
        var error: String?
        var hasUnsavedChanges = false
    }
    
    required init(store: ProfileStore, navigationManager: NavigationManager) {
        self.store = store
        self.navigationManager = navigationManager
        startObserving()
    }
    
//    deinit {
//        stateObservationTask?.cancel()
//    }
    
    private func startObserving() {
        stateObservationTask = Task { [weak self] in
            guard let self else { return }
            
            for await state in await store.stateStream {
                guard !Task.isCancelled else { break }
                
                self.viewState.user = state.user
                self.viewState.isLoading = state.isLoading
                self.viewState.error = state.error
                self.viewState.hasUnsavedChanges = state.hasUnsavedChanges
            }
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
    
    func navigate(to route: ProfileRoute, style: NavigationStyle) {
        navigationManager.navigate(to: route, style: style)
    }
}
