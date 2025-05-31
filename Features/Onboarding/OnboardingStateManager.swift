//
//  OnboardingStateManager.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/30/25.
//

import Foundation
import SwiftUI

@Observable
final class OnboardingStateManager: @unchecked Sendable {
    // Storage keys
    private static let lastCompletedStepKey = "lastCompletedOnboardingStep"
    private static let onboardingCompleteKey = "isOnboardingComplete"
    private static let userAuthenticatedKey = "onboardingUserAuthenticated"
    
    // Dependencies
    private let persistenceService: any LocalPersistenceProtocol
    
    // Observable properties - these trigger UI updates
    private(set) var isOnboardingComplete: Bool = false
    private(set) var userIsAuthenticated: Bool = false
    private(set) var lastCompletedStep: String? = nil
    
    // Computed property for completed steps based on lastCompletedStep
    var completedSteps: Set<OnboardingStep> {
        guard let lastStep = lastCompletedStep else { return [] }
        
        var completed = Set<OnboardingStep>()
        
        // Build completed steps based on the last completed step
        // This assumes a linear progression through required steps
        for step in OnboardingStep.allCases {
            completed.insert(step)
            if step.rawValue == lastStep {
                break
            }
        }
        
        return completed
    }
    
    init(persistenceService: (any LocalPersistenceProtocol)? = nil) {
        self.persistenceService = persistenceService ?? LocalPersistenceService(storageType: .userDefaults)
        
        // Load state synchronously during initialization
        loadState()
    }
    
    private func loadState() {
        // Load completion state
        Task {
            isOnboardingComplete = try await persistenceService.load(Bool.self, forKey: Self.onboardingCompleteKey) ?? false
            
            // Only load onboarding state if not complete
            if !isOnboardingComplete {
                // Load authentication state
                userIsAuthenticated = try await persistenceService.load(Bool.self, forKey: Self.userAuthenticatedKey) ?? false
                
                // Load last completed step
                lastCompletedStep = try await persistenceService.load(String.self, forKey: Self.lastCompletedStepKey) ?? ""
            }
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
    
    var allStepsCompleted: Bool {
        OnboardingStep.allCases.allSatisfy { isStepCompleted($0) }
    }
    
    // MARK: - Public Methods
    
    func isStepCompleted(_ step: OnboardingStep) -> Bool {
        completedSteps.contains(step)
    }
    
    @MainActor
    func setUserAuthenticated(_ authenticated: Bool) {
        Task {
            userIsAuthenticated = authenticated
            try? await persistenceService.save(authenticated, forKey: Self.userAuthenticatedKey)
        }
    }
    
    @MainActor
    func markStepCompleted(_ step: OnboardingStep) {
        // Update last completed step
        Task {
            lastCompletedStep = step.rawValue
            try? await persistenceService.save(step.rawValue, forKey: Self.lastCompletedStepKey)
        }
    }
    
    @MainActor
    func completeOnboarding() {
        // Mark onboarding as complete
        Task {
            isOnboardingComplete = true
            try? await persistenceService.save(true, forKey: Self.onboardingCompleteKey)
            
            // Clear onboarding-specific data
            try? await persistenceService.remove(forKey: Self.lastCompletedStepKey)
            try? await persistenceService.remove(forKey: Self.userAuthenticatedKey)
            
            // Reset in-memory state
            lastCompletedStep = nil
            userIsAuthenticated = false
        }
    }
    
    @MainActor
    func resetOnboarding() {
        // Reset all state
        isOnboardingComplete = false
        userIsAuthenticated = false
        lastCompletedStep = nil
        
        Task {
            // Clear from persistence
            try? await persistenceService.remove(forKey: Self.onboardingCompleteKey)
            try? await persistenceService.remove(forKey: Self.lastCompletedStepKey)
            try? await persistenceService.remove(forKey: Self.userAuthenticatedKey)
        }
    }
}
