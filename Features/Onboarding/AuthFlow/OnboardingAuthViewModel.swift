//
//  OnboardingAuthenticationViewModel.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

@MainActor
@Observable
final class OnboardingAuthenticationViewModel {
    private let navigationManager: NavigationManager
    private let dependencies: AppDependencies
    
    var username = ""
    var password = ""
    var isLoading = false
    var errorMessage: String?
    
    var canAuthenticate: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
    init(navigationManager: NavigationManager, dependencies: AppDependencies) {
        self.navigationManager = navigationManager
        self.dependencies = dependencies
    }
    
    func authenticate() {
        guard canAuthenticate else { return }
        
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                // Simulate authentication
                try await Task.sleep(nanoseconds: 1_500_000_000)
                
                // Demo credentials check
                if username.lowercased() == "demo" && password == "demo" {
                    await dependencies.analyticsService.track(.custom("onboarding_authenticated", parameters: nil))
                    navigateToChecklist()
                } else {
                    throw AuthenticationError.invalidCredentials
                }
            } catch {
                errorMessage = "Invalid username or password"
                await dependencies.analyticsService.track(.custom("onboarding_auth_failed", parameters: nil))
            }
            
            isLoading = false
        }
    }
    
    func skipAuthentication() {
        navigateToChecklist()
    }
    
    private func navigateToChecklist() {
        navigationManager.navigate(to: OnboardingRoute.step(.welcome), style: .push)
    }
}

enum AuthenticationError: Error {
    case invalidCredentials
}
