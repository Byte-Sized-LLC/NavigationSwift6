import Foundation
import SwiftUI

@MainActor
@Observable
final class CategoryViewModel {
    let navigationManager: NavigationManager
    private let userService: UserService

    var categoryId: String
    var fetchedUser: User?
    
    init(categoryId: String, navigationManager: NavigationManager, userService: UserService) {
        self.categoryId = categoryId
        self.navigationManager = navigationManager
        self.userService = userService
    }
    
    func fetchUser() {
        Task { @MainActor in
            fetchedUser = try await userService.fetchCurrentUser()
        }
    }
    
    func navigateToSettings() {
        navigationManager.navigate(to: .settings)
    }
    
    func navigateToFeatured() {
        navigationManager.navigate(to: HomeRoute.featured, style: .push)
    }
    
    func navigateToAccountSettings() {
        navigationManager.navigate(to: SettingsRoute.account, style: .push)
    }
} 
