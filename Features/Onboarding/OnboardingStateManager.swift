//
//  OnboardingStateManager.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/30/25.
//

import Foundation
import SwiftUI

enum AuthenticationState {
    case notAuthenticated
    case authenticated
    case needsOnboarding
    case onboardingComplete
}

@Observable
final class OnboardingStateManager: @unchecked Sendable {
    private let persistenceService: LocalPersistenceService
    
    var completedSteps: Set<OnboardingStep> = []
    var currentStep: OnboardingStep?
    var onboardingComplete: Bool = false
    var isAuthenticated: Bool = false
    var userProfile: UserProfile?
    
    init(persistenceService: LocalPersistenceService) {
        self.persistenceService = persistenceService
        
        // Load state immediately in init
        Task {
            await loadPersistedState()
        }
    }
    
    // MARK: - Public Properties
    var progress: Double {
        let requiredCount = Double(OnboardingStep.requiredSteps.count)
        let completedCount = Double(OnboardingStep.requiredSteps.filter { isStepCompleted($0) }.count)
        return requiredCount > 0 ? completedCount / requiredCount : 0
    }
    
    var allRequiredStepsCompleted: Bool {
        OnboardingStep.requiredSteps.allSatisfy { isStepCompleted($0) }
    }
    
    var needsProfileCompletion: Bool {
        !isStepCompleted(.profile) || userProfile == nil || userProfile?.name.isEmpty == true
    }
    
    var nextIncompleteStep: OnboardingStep? {
        // Find the first step that hasn't been completed
        for step in OnboardingStep.allCases {
            if !isStepCompleted(step) {
                return step
            }
        }
        return nil
    }
    
    var nextRequiredIncompleteStep: OnboardingStep? {
        // Find the first required step that hasn't been completed
        for step in OnboardingStep.requiredSteps {
            if !isStepCompleted(step) {
                return step
            }
        }
        return nil
    }
    
    // MARK: - Public Methods
    func isStepCompleted(_ step: OnboardingStep) -> Bool {
        completedSteps.contains(step)
    }
    
    func setUserAuthenticated(_ authenticated: Bool) {
        isAuthenticated = authenticated
        if authenticated {
            markStepCompleted(.signIn)
        } else {
            // If logging out, reset authentication-related state
            completedSteps.remove(.signIn)
            userProfile = nil
        }
    }
    
    func markStepCompleted(_ step: OnboardingStep) {
        completedSteps.insert(step)
        currentStep = step
        
        // Check if all required steps are now complete
        if allRequiredStepsCompleted && !onboardingComplete {
            // Optionally auto-complete onboarding if all required steps are done
            // You might want to show a completion screen instead
        }
        
        Task {
            await saveState()
        }
    }
    
    func markStepIncomplete(_ step: OnboardingStep) {
        completedSteps.remove(step)
        Task {
            await saveState()
        }
    }
    
    func completeOnboarding() {
        onboardingComplete = true
        currentStep = nil
        Task {
            await saveState()
        }
    }
    
    func resetOnboarding() {
        completedSteps.removeAll()
        currentStep = nil
        onboardingComplete = false
        isAuthenticated = false
        userProfile = nil
        Task {
            await saveState()
            try? await persistenceService.delete(forKey: "user_profile")
        }
    }
    
    func checkAuthenticationState() async -> AuthenticationState {
        // Ensure we have the latest persisted state
        await loadPersistedState()
        
        // Not authenticated
        if !isAuthenticated {
            return .notAuthenticated
        }
        
        // Authenticated but no profile
        if userProfile == nil {
            return .needsOnboarding
        }
        
        // Check if onboarding is complete
        if onboardingComplete {
            return .onboardingComplete
        }
        
        // Check if there are incomplete required steps
        if (nextRequiredIncompleteStep != nil) {
            return .needsOnboarding
        }
        
        // All required steps complete but not marked as complete
        if allRequiredStepsCompleted {
            completeOnboarding()
            return .onboardingComplete
        }
        
        // Default to needing onboarding
        return .needsOnboarding
    }
    
    func getNextStepRoute() -> OnboardingRoute? {
        // If not authenticated, go to authentication
        if !isAuthenticated {
            return .authentication
        }
        
        // Find next incomplete step
        if let nextStep = nextIncompleteStep {
            return .step(nextStep)
        }
        
        // All steps complete, go to checklist
        return .checklist
    }
    
    // MARK: - Private Methods
    @MainActor
    private func loadPersistedState() async {
        // Load onboarding state from UserDefaults
        if let persistedState = try? await persistenceService.loadOnboardingState() {
            let (steps, current, complete, authenticated) = persistedState.toOnboardingState()
            self.completedSteps = steps
            self.currentStep = current
            self.onboardingComplete = complete
            self.isAuthenticated = authenticated
        }
        
        // Load user profile from Keychain
        if let profile = try? await persistenceService.loadUserProfile() {
            self.userProfile = profile
        }
    }
    
    private func saveState() async {
        let model = OnboardingPersistenceModel(
            completedSteps: completedSteps,
            currentStep: currentStep,
            isComplete: onboardingComplete,
            isAuthenticated: isAuthenticated
        )
        
        try? await persistenceService.saveOnboardingState(model)
    }
}
