//
//  TabNavigationView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct TabNavigationView: View {
    let tab: TabItem
    @Environment(\.appRouter) private var appRouter
    @Environment(\.appDependencies) private var dependencies
    
    var body: some View {
        Group {
            switch tab {
            case .home:
                HomeNavigationView()
            case .search:
                SearchNavigationView()
            case .profile:
                ProfileNavigationView()
            case .settings:
                SettingsNavigationView()
            }
        }
    }
}
