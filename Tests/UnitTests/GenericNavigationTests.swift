//
//  GenericNavigationTests.swift
//  GenericNavigationTests
//
//  Created by Dylan Anderson on 5/23/25.
//

import Testing
import SwiftUI
import Foundation
@testable import GenericNavigation

@Suite("Navigation Architecture Tests")
struct NavigationTests {
    
    @Test("Tab Router Navigation")
    func testTabRouterNavigation() async {
        let router = HomeRouter()
        
        await MainActor.run {
            router.navigate(to: .detail(itemId: "123"), style: .push)
            #expect(router.navigationPath.count == 1)
            
            router.popLast()
            #expect(router.navigationPath.count == 0)
            
            router.navigate(to: .list, style: .push)
            router.navigate(to: .featured, style: .push)
            router.popToRoot()
            #expect(router.navigationPath.count == 0)
        }
    }
    
    @Test("Feature Flag Service")
    func testFeatureFlagService() async {
        let service = FeatureFlagService()
        
        // Test default flags
        #expect(service.isEnabled(.newOnboarding) == false)
        
        // Test override
        await service.setOverride(.debugMenu, enabled: true)
        #expect(service.isEnabled(.debugMenu) == true)
        
        // Test clear overrides
        await service.clearOverrides()
    }
    
    @Test("Home Store Actions")
    func testHomeStoreActions() async {
        let dependencies = AppDependencies()
        let store = HomeStore(dependencies: dependencies)
        
        await store.dispatch(.loadItems)
        let state = await store.getState()
        
        #expect(state.isLoading == false)
        #expect(state.items.count > 0)
    }
    
    @Test("Sendable Conformance")
    func testSendableTypes() {
        // These should compile without warnings
        let _: any Sendable = HomeRoute.detail(itemId: "123")
        let _: any Sendable = SearchFilters()
        let _: any Sendable = User(id: "1", name: "Test", email: "test@example.com")
    }
    
    @Test("Actor Isolation")
    func testActorIsolation() async {
        let service = APIService()
        
        // This should be isolated to the actor
        await service.setEnvironment(.development)
        
        // Concurrent access should be safe
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    do {
                        let _: User = try await service.fetchData("user/\(i)")
                    } catch {
                        // Expected to fail in test
                    }
                }
            }
        }
    }
}
