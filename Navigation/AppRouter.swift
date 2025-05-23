//
//  AppRouter.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation
import SwiftUI

@Observable
final class AppRouter: @unchecked Sendable {
    var isOnboardingComplete: Bool {
        didSet {
            UserDefaults.standard.set(isOnboardingComplete, forKey: "isOnboardingComplete")
        }
    }
    
    var currentOnboardingStep: OnboardingStep {
        didSet {
            UserDefaults.standard.set(currentOnboardingStep.rawValue, forKey: "lastCompletedOnboardingStep")
        }
    }
    
    var selectedTab: TabItem = .home
    private(set) var tabRouters: [TabItem: Any] = [:]
    
    init() {
        // Load persisted values
        self.isOnboardingComplete = UserDefaults.standard.bool(forKey: "isOnboardingComplete")
        let savedStep = UserDefaults.standard.string(forKey: "lastCompletedOnboardingStep") ?? OnboardingStep.welcome.rawValue
        self.currentOnboardingStep = OnboardingStep(rawValue: savedStep) ?? .welcome
        
        setupRouters()
    }
    
    private func setupRouters() {
        tabRouters[.home] = HomeRouter()
        tabRouters[.search] = SearchRouter()
        tabRouters[.profile] = ProfileRouter()
        tabRouters[.settings] = SettingsRouter()
    }
    
    func homeRouter() -> HomeRouter {
        return tabRouters[.home] as? HomeRouter ?? HomeRouter()
    }
    
    func searchRouter() -> SearchRouter {
        return tabRouters[.search] as? SearchRouter ?? SearchRouter()
    }
    
    func profileRouter() -> ProfileRouter {
        return tabRouters[.profile] as? ProfileRouter ?? ProfileRouter()
    }
    
    func settingsRouter() -> SettingsRouter {
        return tabRouters[.settings] as? SettingsRouter ?? SettingsRouter()
    }
    
    @MainActor
    func completeOnboarding() {
        isOnboardingComplete = true
        currentOnboardingStep = .completion
    }
    
    @MainActor
    func resetOnboarding() {
        isOnboardingComplete = false
        currentOnboardingStep = .welcome
    }
    
    @MainActor
    func handleDeepLink(_ deepLink: DeepLink, featureFlags: FeatureFlagService) async {
        switch deepLink {
        case .profile(let userId):
            let route = ProfileRoute.main(userId: userId)
            if let requiredFlag = route.featureFlagKey, !featureFlags.isEnabled(requiredFlag) {
                return
            }
            selectedTab = .profile
            profileRouter().push(route)
            
        case .item(let itemId):
            let route = HomeRoute.detail(itemId: itemId)
            if let requiredFlag = route.featureFlagKey, !featureFlags.isEnabled(requiredFlag) {
                return
            }
            selectedTab = .home
            homeRouter().push(route)
            
        case .search(let query):
            selectedTab = .search
            if let query = query {
                searchRouter().push(.results(query: query))
            }
            
        case .settings:
            selectedTab = .settings
        }
    }
}
