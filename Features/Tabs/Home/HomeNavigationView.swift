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
    
    init() {
        let dependencies = AppDependencies()
        let store = HomeStore(dependencies: dependencies)
        _viewModel = State(initialValue: HomeViewModel(store: store))
    }
    
    var body: some View {
        TabNavigationWrapper(
            tab: .home,
            router: appRouter.homeRouter,
            content: {
                HomeView(viewModel: viewModel)
            },
            destinationBuilder: { route in
                destinationView(for: route)
            }
        )
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
            CategoryView(viewModel: CategoryViewModel(
                categoryId: categoryId,
                navigationCoordinator: appRouter,
                userService: dependencies.userService
            ))
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
