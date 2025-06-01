//
//  OnboardingPersistenceModel.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 6/1/25.
//

import Foundation

struct OnboardingPersistenceModel: Codable {
    var completedSteps: Set<String>
    var currentStep: String?
    var isComplete: Bool
    var isAuthenticated: Bool
    var lastUpdated: Date
    
    init(completedSteps: Set<OnboardingStep> = [], currentStep: OnboardingStep? = nil, isComplete: Bool = false, isAuthenticated: Bool = false) {
        self.completedSteps = Set(completedSteps.map { $0.rawValue })
        self.currentStep = currentStep?.rawValue
        self.isComplete = isComplete
        self.isAuthenticated = isAuthenticated
        self.lastUpdated = Date()
    }
    
    func toOnboardingState() -> (completedSteps: Set<OnboardingStep>, currentStep: OnboardingStep?, isComplete: Bool, isAuthenticated: Bool) {
        let steps = completedSteps.compactMap { OnboardingStep(rawValue: $0) }
        let current = currentStep.flatMap { OnboardingStep(rawValue: $0) }
        return (Set(steps), current, isComplete, isAuthenticated)
    }
}
