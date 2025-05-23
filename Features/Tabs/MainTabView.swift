//
//  MainTabView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.appRouter) private var appRouter
    @Environment(\.appDependencies) private var dependencies
    
    var body: some View {
        @Bindable var router = appRouter
        
        TabView(selection: $router.selectedTab) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabNavigationWrapper(tab: tab) {
                    TabNavigationView(tab: tab)
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.icon)
                }
                .tag(tab)
            }
        }
        .onChange(of: appRouter.selectedTab) { _, newTab in
            Task {
                await dependencies.analyticsService.track(.screenView(newTab.title))
            }
        }
    }
}
