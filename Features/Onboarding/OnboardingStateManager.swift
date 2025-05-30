//
//  OnboardingStateManager.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/30/25.
//

import Foundation
import SwiftUI

// MARK: - Onboarding State Model
struct OnboardingState: Codable {
    var isAuthenticated: Bool = false
    var completedSteps: Set<String> = []
    var isComplete: Bool = false
}

@Observable
final class OnboardingStateManager: @unchecked Sendable {
    // Storage keys
    private static let onboardingStateKey = "onboardingState"
    private static let onboardingCompleteKey = "isOnboardingComplete"
    
    // Dependencies
    private let persistenceService: any LocalPersistenceProtocol
    
    // In-memory state - Observable properties
    private var state: OnboardingState = OnboardingState()
    
    // Observable property for completion state
    private(set) var isOnboardingComplete: Bool = false
    
    init(persistenceService: (any LocalPersistenceProtocol)? = nil) {
        self.persistenceService = persistenceService ?? LocalPersistenceService(storageType: .userDefaults)
        
        // Load completion state from UserDefaults
        self.isOnboardingComplete = UserDefaults.standard.bool(forKey: Self.onboardingCompleteKey)
        
        // Load persisted state synchronously during initialization
        Task { @MainActor in
            await loadState()
        }
    }
    
    // MARK: - Public Properties
    
    var userIsAuthenticated: Bool {
        get { state.isAuthenticated }
        set {
            Task { @MainActor in
                state.isAuthenticated = newValue
                await saveState()
            }
        }
    }
    
    var completedSteps: Set<OnboardingStep> {
        Set(state.completedSteps.compactMap { OnboardingStep(rawValue: $0) })
    }
    
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
        state.completedSteps.contains(step.rawValue)
    }
    
    @MainActor
    func markStepCompleted(_ step: OnboardingStep) async {
        state.completedSteps.insert(step.rawValue)
        await saveState()
    }
    
    @MainActor
    func completeOnboarding() async {
        // Clear the onboarding state
        await clearOnboardingState()
        
        // Set completion flag - this will trigger UI update
        isOnboardingComplete = true
        UserDefaults.standard.set(true, forKey: Self.onboardingCompleteKey)
    }
    
    @MainActor
    func resetOnboarding() async {
        state = OnboardingState()
        isOnboardingComplete = false
        UserDefaults.standard.set(false, forKey: Self.onboardingCompleteKey)
        
        await clearOnboardingState()
    }
    
    // MARK: - Private Methods
    
    @MainActor
    private func loadState() async {
        // Only load state if onboarding is not complete
        guard !isOnboardingComplete else { return }
        
        do {
            if let loadedState = try await persistenceService.load(OnboardingState.self, forKey: Self.onboardingStateKey) {
                self.state = loadedState
            }
        } catch {
            print("Failed to load onboarding state: \(error)")
        }
    }
    
    private func saveState() async {
        // Only save if onboarding is not complete
        guard !isOnboardingComplete else { return }
        
        do {
            try await persistenceService.save(state, forKey: Self.onboardingStateKey)
        } catch {
            print("Failed to save onboarding state: \(error)")
        }
    }
    
    private func clearOnboardingState() async {
        do {
            try await persistenceService.remove(forKey: Self.onboardingStateKey)
        } catch {
            print("Failed to clear onboarding state: \(error)")
        }
    }
    
    // MARK: - Debug Helpers
    
#if DEBUG
    func debugPrintState() async {
        print("=== Onboarding State ===")
        print("Authenticated: \(state.isAuthenticated)")
        print("Completed Steps: \(state.completedSteps)")
        print("Is Complete: \(isOnboardingComplete)")
        print("Progress: \(progress)")
        let hasPersistedState = await persistenceService.exists(forKey: Self.onboardingStateKey)
        print("Has Persisted State: \(hasPersistedState)")
        print("=======================")
    }
#endif
}
