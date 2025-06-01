//
//  AppDependencies.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

@Observable
final class AppDependencies: DependencyContainerProtocol, @unchecked Sendable {
    typealias API = APIService
    typealias User = UserService
    typealias Analytics = AnalyticsService
    typealias Persistence = LocalPersistenceService
    
    private let lazy = LazyAppDependencies()
    
    var apiService: APIService {
        lazy.apiService
    }
    
    var userService: UserService {
        lazy.userService
    }
    
    var analyticsService: AnalyticsService {
        lazy.analyticsService
    }
    
    var persistenceService: LocalPersistenceService {
        lazy.persistenceService
    }
}

final class LazyAppDependencies: @unchecked Sendable {
    private var _apiService: APIService?
    private var _userService: UserService?
    private var _analyticsService: AnalyticsService?
    private var _persistenceService: LocalPersistenceService?
    
    var apiService: APIService {
        if _apiService == nil {
            _apiService = APIService()
        }
        return _apiService!
    }
    
    var userService: UserService {
        if _userService == nil {
            _userService = UserService(
                apiService: apiService,
                persistenceService: persistenceService
            )
        }
        return _userService!
    }
    
    var analyticsService: AnalyticsService {
        if _analyticsService == nil {
            _analyticsService = AnalyticsService()
        }
        return _analyticsService!
    }
    
    var persistenceService: LocalPersistenceService {
        if _persistenceService == nil {
            // Initialize with different storage types based on needs
            _persistenceService = LocalPersistenceService(storageType: .userDefaults)
        }
        return _persistenceService!
    }
}
