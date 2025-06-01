//
//  HomeNavigationView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct HomeNavigationView: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(AppDependencies.self) private var dependencies
    @State private var viewModel: HomeViewModel
    
    init(dependencies: AppDependencies) {
        let store = HomeStore(dependencies: dependencies)
        _viewModel = State(initialValue: HomeViewModel(store: store))
    }
    
    var body: some View {
        GenericNavigationWrapper(
            router: appRouter.homeRouter,
            analyticsPrefix: "Home",
            content: {
                HomeView(viewModel: viewModel)
            },
            destinationBuilder: { route in
                destinationView(for: route)
            }
        )
        .tabItem {
            Label(RootTab.home.title, systemImage: RootTab.home.icon)
        }
        .tag(RootTab.home)
        .onAppear {
            viewModel.loadItems()
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: HomeRoute) -> some View {
        switch route {
        case .list:
            HomeView(viewModel: viewModel)
        case .detail(let itemId):
            DetailView(itemId: itemId)
        case .category(let categoryId):
            CategoryView(categoryId: categoryId, navigationManager: appRouter, userService: dependencies.userService)
        case .featured:
            FeaturedView()
        case .newItem:
            NewItemView()
        case .share(itemId: let itemId):
            ShareItemView(itemId: itemId)
        case .quickAdd:
            QuickAddView()
        }
    }
}
