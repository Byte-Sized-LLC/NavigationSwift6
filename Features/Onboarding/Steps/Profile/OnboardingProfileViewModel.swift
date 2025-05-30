//
//  OnboardingProfileViewModel.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

@MainActor
@Observable
final class OnboardingProfileViewModel {
    private let onboardingRouter: OnboardingRouter
    private let dependencies: AppDependencies
    
    var name = ""
    var bio = ""
    var hasPhoto = false
    
    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init(onboardingRouter: OnboardingRouter, dependencies: AppDependencies) {
        self.onboardingRouter = onboardingRouter
        self.dependencies = dependencies
    }
    
    func changePhoto() {
        // Simulate photo selection
        hasPhoto = true
    }
    
    func saveProfile(stateManager: OnboardingStateManager) {
        guard canSave else { return }
        
        Task {
            let profile = UserProfile(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                bio: bio.isEmpty ? nil : bio.trimmingCharacters(in: .whitespacesAndNewlines),
                avatarURL: hasPhoto ? "placeholder_url" : nil
            )
            
            try await dependencies.userService.updateProfile(profile)
            
            await dependencies.analyticsService.track(.custom("onboarding_profile_created", parameters: [
                "has_bio": bio.isEmpty ? "false" : "true",
                "has_photo": hasPhoto ? "true" : "false"
            ]))
            
            completeStep(stateManager: stateManager)
        }
    }
    
    private func completeStep(stateManager: OnboardingStateManager) {
        Task {
            // Mark step as completed using the state manager
            await stateManager.markStepCompleted(.profile)
            onboardingRouter.popLast()
        }
    }
}
