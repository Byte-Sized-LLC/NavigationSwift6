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
    var completedSteps: Set<OnboardingStep> = []
    var onboardingStep: OnboardingStep?
    var onboardingComplete: Bool = false
    
    init() {
        self.onboardingComplete = UserDefaults.standard.bool(forKey: "onboardingComplete")
        let onboardingString = UserDefaults.standard.string(forKey: "onboardingStep") ?? ""
        self.onboardingStep = OnboardingStep(rawValue: onboardingString)
        
        switch onboardingStep {
        case .signIn:
            completedSteps.insert(.signIn)
        case .welcome:
            completedSteps.insert(.signIn)
            completedSteps.insert(.welcome)
        case .permissions:
            completedSteps.insert(.signIn)
            completedSteps.insert(.welcome)
            completedSteps.insert(.permissions)
        case .profile:
            completedSteps.insert(.signIn)
            completedSteps.insert(.welcome)
            completedSteps.insert(.permissions)
            completedSteps.insert(.profile)
        case .preferences:
            completedSteps.insert(.signIn)
            completedSteps.insert(.welcome)
            completedSteps.insert(.permissions)
            completedSteps.insert(.profile)
            completedSteps.insert(.preferences)
        case .none:
            completedSteps = []
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
    
    // MARK: - Public Methods
    func isStepCompleted(_ step: OnboardingStep) -> Bool {
        completedSteps.contains(step)
    }
    
    func setUserAuthenticated(_ authenticated: Bool) {
        completedSteps.insert(.signIn)
        UserDefaults.standard.set(OnboardingStep.signIn.rawValue, forKey: "onboardingStep")
    }
    
    func markStepCompleted(_ step: OnboardingStep) {
        UserDefaults.standard.set(step.rawValue, forKey: "onboardingStep")
        completedSteps.insert(step)
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "onboardingComplete")
        onboardingComplete = true
        onboardingStep = nil
    }
}
