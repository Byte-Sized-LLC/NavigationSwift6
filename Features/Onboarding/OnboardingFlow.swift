//
//  OnboardingFlow.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct OnboardingFlow: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(AppDependencies.self) private var dependencies
    
    var body: some View {
        NavigationStack {
            OnboardingStepView(step: appRouter.currentOnboardingStep) {
                Task {
                    await advanceStep()
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func advanceStep() async {
        await dependencies.analyticsService.track(.custom("onboarding_step_completed", parameters: ["step": appRouter.currentOnboardingStep.rawValue]))
        
        await MainActor.run {
            if let nextStep = appRouter.currentOnboardingStep.next {
                appRouter.currentOnboardingStep = nextStep
            } else {
                appRouter.completeOnboarding()
            }
        }
    }
}
