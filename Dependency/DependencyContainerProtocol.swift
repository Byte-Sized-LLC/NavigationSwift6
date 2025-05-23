//
//  DependencyContainerProtocol.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

protocol DependencyContainerProtocol: Sendable {
    associatedtype API: APIServiceProtocol
    associatedtype User: UserServiceProtocol
    associatedtype Analytics: AnalyticsServiceProtocol
    
    var apiService: API { get }
    var userService: User { get }
    var analyticsService: Analytics { get }
}

