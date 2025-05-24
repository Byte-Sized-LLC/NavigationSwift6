import Foundation
import SwiftUI

@MainActor
@Observable
final class CategoryViewModel {
    private let appRouter: AppRouter
    private let userService: UserService

    var categoryId: String
    var fetchedUser: User?
    
    init(categoryId: String, appRouter: AppRouter, userService: UserService) {
        self.categoryId = categoryId
        self.appRouter = appRouter
        self.userService = userService
    }
    
    func fetchUser() {
        Task { @MainActor in
            fetchedUser = try await userService.fetchCurrentUser()
        }
    }
    
    func navigateToSettings() {
        appRouter.selectedTab = .settings
    }
    
    func navigateToFeatured() {
        appRouter.homeRouter.push(.featured)
    }
    
    func navigateToAccountSettings() {
        appRouter.settingsRouter.push(.account)
    }
} 
