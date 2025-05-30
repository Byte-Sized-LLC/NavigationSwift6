//
//  OnboardingStateManager.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/30/25.
//

import Foundation
import SwiftUI

// Environment key for OnboardingStateManager
private struct OnboardingStateManagerKey: EnvironmentKey {
    static let defaultValue = OnboardingStateManager()
}

extension EnvironmentValues {
    var onboardingStateManager: OnboardingStateManager {
        get { self[OnboardingStateManagerKey.self] }
        set { self[OnboardingStateManagerKey.self] = newValue }
    }
}

@Observable
final class OnboardingStateManager: @unchecked Sendable {
    @ObservationIgnored
    @AppStorage("completedOnboardingSteps") private var completedStepsData = Data()
    
    @ObservationIgnored
    @AppStorage("isOnboardingComplete") private var isOnboardingComplete: Bool = false
    
    @ObservationIgnored
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    private(set) var completedSteps: Set<OnboardingStep> = []
    
    init() {
        loadCompletedSteps()
    }
    
    var progress: Double {
        let requiredCount = Double(OnboardingStep.requiredSteps.count)
        let completedCount = Double(OnboardingStep.requiredSteps.filter { completedSteps.contains($0) }.count)
        return requiredCount > 0 ? completedCount / requiredCount : 0
    }
    
    var allRequiredStepsCompleted: Bool {
        OnboardingStep.requiredSteps.allSatisfy { completedSteps.contains($0) }
    }
    
    var allStepsCompleted: Bool {
        OnboardingStep.allCases.allSatisfy { completedSteps.contains($0) }
    }
    
    func isStepCompleted(_ step: OnboardingStep) -> Bool {
        completedSteps.contains(step)
    }
    
    func markStepCompleted(_ step: OnboardingStep) {
        completedSteps.insert(step)
        saveCompletedSteps()
    }
    
    func completeOnboarding() {
        isOnboardingComplete = true
        hasSeenOnboarding = true
    }
    
    func resetOnboarding() {
        completedSteps.removeAll()
        isOnboardingComplete = false
        hasSeenOnboarding = false
        saveCompletedSteps()
    }
    
    private func loadCompletedSteps() {
        if let decoded = try? JSONDecoder().decode(Set<String>.self, from: completedStepsData) {
            completedSteps = Set(decoded.compactMap { OnboardingStep(rawValue: $0) })
        }
    }
    
    private func saveCompletedSteps() {
        let stepStrings = completedSteps.map { $0.rawValue }
        if let encoded = try? JSONEncoder().encode(stepStrings) {
            completedStepsData = encoded
        }
    }
}
