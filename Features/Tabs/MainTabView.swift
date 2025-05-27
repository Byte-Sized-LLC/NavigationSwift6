//
//  MainTabView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct MainTabView: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(AppDependencies.self) private var dependencies
    
    var body: some View {
        @Bindable var router = appRouter
        
        TabView(selection: $router.selectedTab) {
            HomeNavigationView()
            ProfileNavigationView()
            SearchNavigationView()
            SettingsNavigationView()
        }
    }
}
