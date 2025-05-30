// OnboardingFlow.swift
//
//  OnboardingFlow.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct OnboardingFlow: View {
    @Environment(OnboardingRouter.self) private var appRouter
    @Environment(AppDependencies.self) private var dependencies
    @State private var isAuthenticated = false
    @State private var completedSteps: Set<OnboardingStep> = []
    
    var body: some View {
        /// Find a way to use the navigationwrapper here 
//        TabNavigationWrapper {
//            
//        }
//            Group {
//                if !isAuthenticated {
//                    Text("use the auth view")
////                    OnboardingAuthenticationView(navigationManager: appRouter as! NavigationManager, dependencies: dependencies)
//                } else {
//                    OnboardingChecklistView(completedSteps: $completedSteps)
//                        .navigationDestination(for: OnboardingStep.self) { step in
//                            OnboardingStepView(step: step) {
//                                Task {
//                                    await completeStep(step)
//                                }
//                            }
//                            .navigationTitle(step.navigationTitle)
//                            .navigationBarTitleDisplayMode(.inline)
//                        }
//                }
//            }
        
    }
    
    private func completeStep(_ step: OnboardingStep) async {
        await dependencies.analyticsService.track(.custom("onboarding_step_completed", parameters: ["step": step.rawValue]))
    }
}
