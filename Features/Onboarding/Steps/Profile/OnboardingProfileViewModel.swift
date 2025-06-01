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
    private let localPersistenceService: LocalPersistenceService
    private let userService: UserService
    private let analyticsService: AnalyticsService

    var name = ""
    var bio = ""
    var hasPhoto = false
    var isLoading = false
    
    init(onboardingRouter: OnboardingRouter, localPersistenceService: LocalPersistenceService, userService: UserService, analyticsService: AnalyticsService) {
        self.onboardingRouter = onboardingRouter
        self.localPersistenceService = localPersistenceService
        self.userService = userService
        self.analyticsService = analyticsService
    }
    
    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func loadExistingProfile(from stateManager: OnboardingStateManager) {
        // If we have a profile already, pre-fill the form
        if let profile = stateManager.userProfile {
            self.name = profile.name
            self.bio = profile.bio ?? ""
            self.hasPhoto = profile.avatarURL != nil
        } else {
            // Try loading from persistence
            Task {
                if let profile = try? await localPersistenceService.loadUserProfile() {
                    self.name = profile.name
                    self.bio = profile.bio ?? ""
                    self.hasPhoto = profile.avatarURL != nil
                    stateManager.userProfile = profile
                }
            }
        }
    }
    
    func changePhoto() {
        // Simulate photo selection
        hasPhoto = true
    }
    
    func saveProfile(stateManager: OnboardingStateManager) {
        guard canSave else { return }
        
        Task {
            isLoading = true
            
            let profile = UserProfile(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                bio: bio.isEmpty ? nil : bio.trimmingCharacters(in: .whitespacesAndNewlines),
                avatarURL: hasPhoto ? "placeholder_url" : nil
            )
            
            do {
                // Save to both UserService (which saves to keychain) and update state manager
                try await userService.updateProfile(profile)
                stateManager.userProfile = profile
                
                await analyticsService.track(.custom("onboarding_profile_created", parameters: [
                    "has_bio": bio.isEmpty ? "false" : "true",
                    "has_photo": hasPhoto ? "true" : "false",
                    "is_update": stateManager.isStepCompleted(.profile) ? "true" : "false"
                ]))
                
                completeStep(stateManager: stateManager)
            } catch {
                print("Failed to save profile: \(error)")
                // Show error to user
            }
            
            isLoading = false
        }
    }
    
    func skipStep() {
        onboardingRouter.popLast()
    }
    
    private func completeStep(stateManager: OnboardingStateManager) {
        stateManager.markStepCompleted(.profile)
        onboardingRouter.popLast()
    }
}
