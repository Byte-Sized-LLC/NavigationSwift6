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
    
    var body: some View {
        OnboardingNavigationWrapper(
            router: router,
            content: {
                // If authenticated, go directly to checklist
                if stateManager.userIsAuthenticated {
                    OnboardingChecklistView()
                } else {
                    OnboardingAuthenticationView()
                }
            },
            destinationBuilder: { route in
                destinationView(for: route)
            }
        )
        .onAppear {
            // If user is authenticated but hasn't navigated to checklist yet
            if stateManager.userIsAuthenticated && router.navigationPath.isEmpty {
                router.navigate(to: .checklist, style: .push)
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: OnboardingRoute) -> some View {
        switch route {
        case .authentication:
            OnboardingAuthenticationView()
        case .checklist:
            OnboardingChecklistView()
        case .step(let step):
            switch step {
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

struct OnboardingNavigationWrapper<Content: View>: View {
    let content: Content
    @Bindable var router: OnboardingRouter
    let destinationBuilder: (OnboardingRoute) -> AnyView
    @Environment(\.analyticsService) private var analytics
    
    init(
        router: OnboardingRouter,
        @ViewBuilder content: () -> Content,
        @ViewBuilder destinationBuilder: @escaping (OnboardingRoute) -> some View
    ) {
        self._router = Bindable(router)
        self.content = content()
        self.destinationBuilder = { AnyView(destinationBuilder($0)) }
    }
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            content
                .navigationDestination(for: OnboardingRoute.self) { route in
                    destinationBuilder(route)
                        .onAppear {
                            Task {
                                await analytics.track(.screenView("Onboarding - \(route.id)"))
                            }
                        }
                }
        }
        .sheet(item: $router.sheetItem) { sheet in
            destinationBuilder(sheet.route)
                .onAppear {
                    Task {
                        await analytics.track(.screenView("Onboarding Sheet - \(sheet.route.id)"))
                    }
                }
        }
        .alert(item: $router.alertItem) { alert in
            alert.alert
        }
    }
}
