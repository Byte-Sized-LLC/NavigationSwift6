//
//  TabNavigatorWrapper.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct TabNavigationWrapper<Content: View, Router: RoutableNavigation & Observable>: View {
    let content: Content
    let tab: RootTab
    @Bindable var router: Router
    let destinationBuilder: (Router.Route) -> AnyView
    @Environment(\.analyticsService) private var analytics
    
    init(
        tab: RootTab,
        router: Router,
        @ViewBuilder content: () -> Content,
        @ViewBuilder destinationBuilder: @escaping (Router.Route) -> some View
    ) {
        self.tab = tab
        self._router = Bindable(router)
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
                                await analytics.track(.screenView("\(tab.title) - \(route.id)"))
                            }
                        }
                }
                .navigationDestination(for: WebRoute.self) { route in
                    Text("webview here \(route)")
                        .onAppear {
                            Task {
                                await analytics.track(.screenView("\(tab.title) WebView"))
                            }
                        }
                }
        }
        .sheet(item: $router.sheetItem) { sheet in
            destinationBuilder(sheet.route)
                .onAppear {
                    Task {
                        await analytics.track(.screenView("\(tab.title) Sheet - \(sheet.route.id)"))
                    }
                }
        }
        .alert(item: $router.alertItem) { alert in
            alert.alert
        }
        .tabItem {
            Label(tab.title, systemImage: tab.icon)
        }
        .tag(tab)
        .task {
            await analytics.track(.screenView(tab.title))
        }
    }
}

// MARK: - Tab Configuration
extension TabNavigationWrapper {
    struct Configuration {
        let title: String
        let icon: String
        let selectedIcon: String?
        
        static func standard(title: String, icon: String) -> Configuration {
            Configuration(title: title, icon: icon, selectedIcon: nil)
        }
        
        static func withSelected(title: String, icon: String, selectedIcon: String) -> Configuration {
            Configuration(title: title, icon: icon, selectedIcon: selectedIcon)
        }
    }
}
