import Foundation
import SwiftUI

@MainActor
@Observable
final class CategoryViewModel {
    let navigationCoordinator: NavigationCoordinator
    private let userService: UserService

    var categoryId: String
    var fetchedUser: User?
    
    init(categoryId: String, navigationCoordinator: NavigationCoordinator, userService: UserService) {
        self.categoryId = categoryId
        self.navigationCoordinator = navigationCoordinator
        self.userService = userService
    }
    
    func fetchUser() {
        Task { @MainActor in
            fetchedUser = try await userService.fetchCurrentUser()
        }
    }
    
    func navigateToSettings() {
        navigationCoordinator.navigate(to: .settings)
    }
    
    func navigateToFeatured() {
        navigationCoordinator.navigate(to: HomeRoute.featured, style: .push)
    }
    
    func navigateToAccountSettings() {
        navigationCoordinator.navigate(to: SettingsRoute.account, style: .push)
    }
} 
