//
//  OnboardingPreferencesViewModel.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

@MainActor
@Observable
final class OnboardingPreferencesViewModel {
    private let navigationManager: NavigationManager
    private let dependencies: AppDependencies
    
    var dailyDigest = true
    var autoPlayVideos = false
    var showOnlineStatus = true
    var selectedLanguage = "English"
    
    let languages = ["English", "Spanish", "French"]
    
    init(navigationManager: NavigationManager, dependencies: AppDependencies) {
        self.navigationManager = navigationManager
        self.dependencies = dependencies
    }
    
    func savePreferences() {
        Task {
            // Save preferences to UserDefaults or backend
            UserDefaults.standard.set(dailyDigest, forKey: "preference_daily_digest")
            UserDefaults.standard.set(autoPlayVideos, forKey: "preference_auto_play")
            UserDefaults.standard.set(showOnlineStatus, forKey: "preference_online_status")
            UserDefaults.standard.set(selectedLanguage, forKey: "preference_language")
            
            await dependencies.analyticsService.track(.custom("onboarding_preferences_saved", parameters: [
                "daily_digest": String(dailyDigest),
                "auto_play": String(autoPlayVideos),
                "online_status": String(showOnlineStatus),
                "language": selectedLanguage
            ]))
            
            completeStep()
        }
    }
    
    private func completeStep() {
        if let router = navigationManager as? OnboardingRouter {
            if let checklistVM = router.checklistViewModel {
                checklistVM.markStepCompleted(.preferences)
            }
            router.popLast()
        }
    }
}
