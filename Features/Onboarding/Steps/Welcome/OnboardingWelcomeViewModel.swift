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
    private let onboardingRouter: OnboardingRouter
    private let dependencies: AppDependencies
    
    var waveAnimation = false
    
    init(onboardingRouter: OnboardingRouter, dependencies: AppDependencies) {
        self.onboardingRouter = onboardingRouter
        self.dependencies = dependencies
    }
    
    func startAnimation() {
        waveAnimation = true
    }
    
    func completeStep(stateManager: OnboardingStateManager) {
        Task {
            await dependencies.analyticsService.track(.custom("onboarding_welcome_completed", parameters: nil))
            await stateManager.markStepCompleted(.welcome)
            onboardingRouter.popLast()
        }
    }
}
