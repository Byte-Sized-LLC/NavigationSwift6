//
//  TabNavigatorWrapper.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct TabNavigationWrapper<Content: View>: View {
    let content: Content
    let tab: TabItem
    @Environment(\.analyticsService) private var analytics
    
    init(tab: TabItem, @ViewBuilder content: () -> Content) {
        self.tab = tab
        self.content = content()
    }
    
    var body: some View {
        content
            .task {
                await analytics.track(.screenView(tab.title))
            }
    }
}
