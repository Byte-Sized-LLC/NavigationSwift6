//
//  OnboardingFlow.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct OnboardingFlow: View {
    @Environment(OnboardingRouter.self) private var router
    @Environment(AppDependencies.self) private var dependencies
    @Environment(OnboardingStateManager.self) private var stateManager
    
    @State private var isLoading = true
    @State private var initialRoute: OnboardingRoute?
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading...")
                    .task {
                        await determineInitialRoute()
                    }
            } else {
                GenericNavigationWrapper(router: router, analyticsPrefix: "Onboarding") {
                    if let route = initialRoute {
                        destinationView(for: route)
                    } else {
                        // Default to authentication if no route determined
                        OnboardingAuthenticationView(onboardingRouter: router, dependencies: dependencies)
                    }
                } destinationBuilder: { route in
                    destinationView(for: route)
                }
            }
        }
    }
    
    private func determineInitialRoute() async {
        let authState = await stateManager.checkAuthenticationState()
        
        switch authState {
        case .notAuthenticated:
            initialRoute = .authentication
        case .authenticated, .onboardingComplete:
            // Should not be in onboarding flow
            initialRoute = nil
        case .needsOnboarding:
            initialRoute = .checklist
        }
        
        isLoading = false
    }
    
    @ViewBuilder
    private func destinationView(for route: OnboardingRoute) -> some View {
        switch route {
        case .authentication:
            OnboardingAuthenticationView(onboardingRouter: router, dependencies: dependencies)
        case .checklist:
            OnboardingChecklistView()
        case .step(let step):
            switch step {
            case .signIn:
                OnboardingAuthenticationView(onboardingRouter: router, dependencies: dependencies)
            case .welcome:
                OnboardingWelcomeView(
                    onboardingRouter: router,
                    dependencies: dependencies
                )
            case .permissions:
                OnboardingPermissionsView(
                    onboardingRouter: router,
                    dependencies: dependencies
                )
            case .profile:
                OnboardingProfileView(
                    onboardingRouter: router,
                    dependencies: dependencies
                )
            case .preferences:
                OnboardingPreferencesView(
                    onboardingRouter: router,
                    dependencies: dependencies
                )
            }
        }
    }
}


