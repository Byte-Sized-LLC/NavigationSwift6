//
//  OnboardingViewModel.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/30/25.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class OnboardingViewModel {
    private let navigationManager: NavigationManager
    private let dependencies: AppDependencies
    
    private(set) var isAuthenticated = false
    private(set) var completedSteps: Set<OnboardingStep> = []
    
    init(navigationManager: NavigationManager, dependencies: AppDependencies) {
        self.navigationManager = navigationManager
        self.dependencies = dependencies
    }
    
    func authenticate() {
        isAuthenticated = true
    }
    
    func markStepCompleted(_ step: OnboardingStep) {
        completedSteps.insert(step)
        Task {
            await dependencies.analyticsService.track(
                .custom("onboarding_step_completed",
                        parameters: ["step": step.rawValue])
            )
        }
    }
    
    func navigateToStep(_ step: OnboardingStep) {
        navigationManager.navigate(to: OnboardingRoute.step(step), style: .push)
    }
    
    func showSkipOptionalAlert() {
//        navigationManager.showAlert(.skipOptionalSteps)
    }
    
    func showCompletionAlert() {
//        navigationManager.showAlert(.onboardingComplete)
    }
    
    func completeOnboarding() {
        Task {
            await dependencies.analyticsService.track(
                .custom("onboarding_completed",
                        parameters: [
                            "completed_steps": "\(completedSteps.count)",
                            "skipped_optional": "\(!allStepsCompleted)"
                        ])
            )
            
            // Navigate to main app
            if let appRouter = navigationManager as? AppRouter {
            }
        }
    }
    
    var progressPercentage: CGFloat {
        let totalSteps = OnboardingStep.allCases.count
        let completedCount = completedSteps.count
        return CGFloat(completedCount) / CGFloat(totalSteps)
    }
    
    var allRequiredStepsCompleted: Bool {
        OnboardingStep.requiredSteps.allSatisfy { step in
            completedSteps.contains(step)
        }
    }
    
    var allStepsCompleted: Bool {
        OnboardingStep.allCases.allSatisfy { step in
            completedSteps.contains(step)
        }
    }
}
