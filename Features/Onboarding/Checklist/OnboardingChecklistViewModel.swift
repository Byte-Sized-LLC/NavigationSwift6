//
//  OnboardingChecklistViewModel.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class OnboardingChecklistViewModel {
    private let onboardingRouter: OnboardingRouter
    private let dependencies: AppDependencies
    
    @ObservationIgnored
    @AppStorage("completedOnboardingSteps") private var completedStepsData = Data()
    
    private(set) var completedSteps: Set<OnboardingStep> = []
    
    var progress: Double {
        let requiredCount = Double(OnboardingStep.requiredSteps.count)
        let completedCount = Double(OnboardingStep.requiredSteps.filter { completedSteps.contains($0) }.count)
        return requiredCount > 0 ? completedCount / requiredCount : 0
    }
    
    var canShowOptionalSteps: Bool {
        OnboardingStep.requiredSteps.allSatisfy { completedSteps.contains($0) }
    }
    
    var canCompleteOnboarding: Bool {
        canShowOptionalSteps
    }
    
    init(onboardingRouter: OnboardingRouter, dependencies: AppDependencies) {
        self.onboardingRouter = onboardingRouter
        self.dependencies = dependencies
        loadCompletedSteps()
    }
    
    func checkProgress() {
        loadCompletedSteps()
    }
    
    func isStepCompleted(_ step: OnboardingStep) -> Bool {
        completedSteps.contains(step)
    }
    
    func navigateToStep(_ step: OnboardingStep) {
        onboardingRouter.navigate(to: OnboardingRoute.step(step), style: .push)
    }
    
    func markStepCompleted(_ step: OnboardingStep) {
        completedSteps.insert(step)
        saveCompletedSteps()
        
        Task {
            await dependencies.analyticsService.track(.custom("onboarding_step_completed", parameters: ["step": step.rawValue]))
        }
    }
    
    func completeOnboarding() {
        print("find a way to navigate to tab root stack and navigate there on approuter")
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
