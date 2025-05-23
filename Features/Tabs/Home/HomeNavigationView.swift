//
//  HomeNavigationView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct HomeNavigationView: View {
    @Environment(\.appRouter) private var appRouter
    @Environment(\.appDependencies) private var dependencies
    @State private var viewModel: HomeViewModel
    
    init() {
        let dependencies = AppDependencies()
        let store = HomeStore(dependencies: dependencies)
        _viewModel = State(initialValue: HomeViewModel(store: store))
    }
    
    var router: HomeRouter {
        appRouter.homeRouter()
    }
    
    var body: some View {
        @Bindable var routerBinding = router
        
        NavigationStack(path: $routerBinding.path) {
            HomeView(viewModel: viewModel)
                .navigationDestination(for: HomeRoute.self) { route in
                    destinationView(for: route)
                }
        }
        .sheet(item: $routerBinding.presentedSheet) { sheet in
            sheetView(for: sheet)
        }
        .alert(item: $routerBinding.alertItem) { alert in
            alertView(for: alert)
        }
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
            CategoryView(categoryId: categoryId)
        case .featured:
            FeaturedView()
        }
    }
    
    @ViewBuilder
    private func sheetView(for sheet: HomeSheet) -> some View {
        switch sheet {
        case .newItem:
            NewItemView()
                .presentationDetents([.medium, .large])
        case .share(let itemId):
            ShareItemView(itemId: itemId)
                .presentationDetents([.medium])
        case .quickAdd:
            QuickAddView()
                .presentationDetents([.height(200)])
        }
    }
    
    private func alertView(for alert: HomeAlert) -> Alert {
        switch alert.type {
        case .deleteItem(let itemId):
            return Alert(
                title: Text("Delete Item"),
                message: Text("Are you sure you want to delete this item?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let item = viewModel.viewState.items.first(where: { $0.id == itemId }) {
                        viewModel.deleteItem(item)
                    }
                },
                secondaryButton: .cancel()
            )
        case .error(let message):
            return Alert(
                title: Text("Error"),
                message: Text(message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
