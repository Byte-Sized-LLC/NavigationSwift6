//
//  OnboardingWelcomeViewModel.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

@MainActor
@Observable
final class OnboardingWelcomeViewModel {
    private let navigationManager: NavigationManager
    private let dependencies: AppDependencies
    
    var waveAnimation = false
    
    init(navigationManager: NavigationManager, dependencies: AppDependencies) {
        self.navigationManager = navigationManager
        self.dependencies = dependencies
    }
    
    func startAnimation() {
        waveAnimation = true
    }
    
    func completeStep() {
        Task {
            await dependencies.analyticsService.track(.custom("onboarding_welcome_completed", parameters: nil))
        }
    }
}
