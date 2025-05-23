//
//  Router.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation
import SwiftUI

typealias HomeRouter = Router<HomeRoute, HomeSheet, HomeAlert>
typealias SearchRouter = Router<SearchRoute, SearchSheet, Never>
typealias ProfileRouter = Router<ProfileRoute, ProfileSheet, ProfileAlert>
typealias SettingsRouter = Router<SettingsRoute, SettingsSheet, Never>

@Observable
final class Router<Route: AppRoute, Sheet: Identifiable & Sendable, Alert: Identifiable & Sendable>: @unchecked Sendable {
    var path = NavigationPath()
    var presentedSheet: Sheet?
    var alertItem: Alert?
    
    @MainActor
    func push(_ route: Route) {
        path.append(route)
    }
    
    @MainActor
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    @MainActor
    func popToRoot() {
        path = NavigationPath()
    }
    
    @MainActor
    func setRoot(_ route: Route) {
        path = NavigationPath()
        path.append(route)
    }
    
    @MainActor
    func presentSheet(_ sheet: Sheet) {
        presentedSheet = sheet
    }
    
    @MainActor
    func dismissSheet() {
        presentedSheet = nil
    }
    
    @MainActor
    func showAlert(_ alert: Alert) {
        alertItem = alert
    }
}
