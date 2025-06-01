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
    private var continuation: AsyncStream<HomeState>.Continuation?
    
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
        case deleteItem(Item)
        case addItem(Item)
        case updateItem(Item)
    }
    
    var stateStream: AsyncStream<HomeState> {
        AsyncStream { continuation in
            self.continuation = continuation
            continuation.yield(state)
        }
    }
    
    func getState() -> HomeState {
        state
    }
    
    func dispatch(_ action: HomeAction) async {
        switch action {
        case .loadItems:
            state.isLoading = true
            state.error = nil
            continuation?.yield(state)
            
            do {
                // Load from SwiftData persistence
                let savedItems = try await dependencies.persistenceService.loadItems()
                
                if savedItems.isEmpty {
                    // If no saved items, fetch from API
                    let apiItems = try await fetchItemsFromAPI()
                    await dispatch(.itemsLoaded(apiItems))
                    
                    // Save to persistence
                    for item in apiItems {
                        try await dependencies.persistenceService.saveItem(item)
                    }
                } else {
                    await dispatch(.itemsLoaded(savedItems))
                }
            } catch {
                await dispatch(.loadFailed(error.localizedDescription))
            }
            
        case .itemsLoaded(let items):
            state.items = items
            state.isLoading = false
            continuation?.yield(state)
            
        case .loadFailed(let error):
            state.error = error
            state.isLoading = false
            continuation?.yield(state)
            
        case .selectCategory(let category):
            state.selectedCategory = category
            continuation?.yield(state)
            await dispatch(.loadItems)
            
        case .deleteItem(let item):
            state.items.removeAll { $0.id == item.id }
            continuation?.yield(state)
            
            // Delete from persistence
            do {
                try await dependencies.persistenceService.deleteItem(item)
            } catch {
                print("Failed to delete item: \(error)")
            }
            
        case .addItem(let item):
            state.items.append(item)
            continuation?.yield(state)
            
            // Save to persistence
            do {
                try await dependencies.persistenceService.saveItem(item)
            } catch {
                print("Failed to save item: \(error)")
            }
            
        case .updateItem(let updatedItem):
            if let index = state.items.firstIndex(where: { $0.id == updatedItem.id }) {
                state.items[index] = updatedItem
                continuation?.yield(state)
                
                // Update in persistence
                do {
                    try await dependencies.persistenceService.saveItem(updatedItem)
                } catch {
                    print("Failed to update item: \(error)")
                }
            }
        }
    }
    
    private func fetchItemsFromAPI() async throws -> [Item] {
        // Simulate API call
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return [
            Item(id: UUID().uuidString, title: "Item 1", description: "Description 1"),
            Item(id: UUID().uuidString, title: "Item 2", description: "Description 2"),
            Item(id: UUID().uuidString, title: "Item 3", description: "Description 3")
        ]
    }
}
