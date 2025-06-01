//
//  GenericNavigationWrapper.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 6/1/25.
//

import SwiftUI

struct GenericNavigationWrapper<Content: View, Router: RoutableNavigation & Observable>: View {
    let content: Content
    @Bindable var router: Router
    let destinationBuilder: (Router.Route) -> AnyView
    let analyticsPrefix: String
    @Environment(\.analyticsService) private var analytics
    
    init(
        router: Router,
        analyticsPrefix: String,
        @ViewBuilder content: () -> Content,
        @ViewBuilder destinationBuilder: @escaping (Router.Route) -> some View
    ) {
        self._router = Bindable(router)
        self.analyticsPrefix = analyticsPrefix
        self.content = content()
        self.destinationBuilder = { AnyView(destinationBuilder($0)) }
    }
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            content
                .navigationDestination(for: Router.Route.self) { route in
                    destinationBuilder(route)
                        .onAppear {
                            Task {
                                await analytics.track(.screenView("\(analyticsPrefix) - \(route.id)"))
                            }
                        }
                }
                .navigationDestination(for: WebRoute.self) { route in
                    Text("WebView: \(route)")
                        .onAppear {
                            Task {
                                await analytics.track(.screenView("\(analyticsPrefix) WebView"))
                            }
                        }
                }
        }
        .sheet(item: $router.sheetItem) { sheet in
            destinationBuilder(sheet.route)
                .presentationDetents(sheet.detents)
                .onAppear {
                    Task {
                        await analytics.track(.screenView("\(analyticsPrefix) Sheet - \(sheet.route.id)"))
                    }
                }
        }
        .alert(item: $router.alertItem) { alert in
            alert.alert
        }
    }
}
