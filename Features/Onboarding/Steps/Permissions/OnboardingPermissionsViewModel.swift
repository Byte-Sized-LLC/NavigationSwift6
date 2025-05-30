//
//  OnboardingPermissionsViewModel.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

@MainActor
@Observable
final class OnboardingPermissionsViewModel {
    private let onboardingRouter: OnboardingRouter
    private let dependencies: AppDependencies
    
    var notificationsGranted = false
    var cameraGranted = false
    var locationGranted = false
    var hasRequestedPermissions = false
    
    init(onboardingRouter: OnboardingRouter, dependencies: AppDependencies) {
        self.onboardingRouter = onboardingRouter
        self.dependencies = dependencies
    }
    
    func requestPermissions(stateManager: OnboardingStateManager) {
        if hasRequestedPermissions {
            completeStep(stateManager: stateManager)
            return
        }
        
        Task {
            // Simulate permission requests
            try await Task.sleep(nanoseconds: 500_000_000)
            notificationsGranted = true
            
            try await Task.sleep(nanoseconds: 300_000_000)
            cameraGranted = true
            
            try await Task.sleep(nanoseconds: 300_000_000)
            locationGranted = true
            
            hasRequestedPermissions = true
            
            await dependencies.analyticsService.track(.custom("onboarding_permissions_granted", parameters: [
                "notifications": "true",
                "camera": "true",
                "location": "true"
            ]))
        }
    }
    
    func skipPermissions(stateManager: OnboardingStateManager) {
        Task {
            await dependencies.analyticsService.track(.custom("onboarding_permissions_skipped", parameters: nil))
            completeStep(stateManager: stateManager)
        }
    }
    
    private func completeStep(stateManager: OnboardingStateManager) {
        // Mark step as completed using the state manager
        stateManager.markStepCompleted(.permissions)
        onboardingRouter.popLast()
    }
}
