//
//  HomeStore.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

actor HomeStore: Store {
    private var state: HomeState
    private let dependencies: AppDependencies
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        self.state = HomeState()
    }
    
    struct HomeState: Sendable {
        var items: [Item] = []
        var isLoading = false
        var error: String?
        var selectedCategory: String?
    }
    
    enum HomeAction: Sendable {
        case loadItems
        case itemsLoaded([Item])
        case loadFailed(String)
        case selectCategory(String?)
        case deleteItem(String)
    }
    
    func getState() -> HomeState {
        state
    }
    
    func dispatch(_ action: HomeAction) async {
        switch action {
        case .loadItems:
            state.isLoading = true
            state.error = nil
            
            do {
                // Simulate async loading
                try await Task.sleep(nanoseconds: 1_000_000_000)
                let items = [
                    Item(id: "1", title: "Item 1", description: "Description 1", imageURL: nil),
                    Item(id: "2", title: "Item 2", description: "Description 2", imageURL: nil)
                ]
                await dispatch(.itemsLoaded(items))
            } catch {
                await dispatch(.loadFailed(error.localizedDescription))
            }
            
        case .itemsLoaded(let items):
            state.items = items
            state.isLoading = false
            
        case .loadFailed(let error):
            state.error = error
            state.isLoading = false
            
        case .selectCategory(let category):
            state.selectedCategory = category
            await dispatch(.loadItems)
            
        case .deleteItem(let itemId):
            state.items.removeAll { $0.id == itemId }
        }
    }
}
