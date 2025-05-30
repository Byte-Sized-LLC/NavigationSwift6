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
    private let navigationManager: NavigationManager
    private let dependencies: AppDependencies
    
    var name = ""
    var bio = ""
    var hasPhoto = false
    
    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init(navigationManager: NavigationManager, dependencies: AppDependencies) {
        self.navigationManager = navigationManager
        self.dependencies = dependencies
    }
    
    func changePhoto() {
        // Simulate photo selection
        hasPhoto = true
    }
    
    func saveProfile() {
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
            
            completeStep()
        }
    }
    
    private func completeStep() {

    }
}
