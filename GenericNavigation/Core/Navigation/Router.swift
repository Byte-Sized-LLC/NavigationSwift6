//
//  Router.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation
import SwiftUI

typealias HomeRouter = Router<HomeRoute, AppAlert>
typealias SearchRouter = Router<SearchRoute, AppAlert>
typealias ProfileRouter = Router<ProfileRoute, AppAlert>
typealias SettingsRouter = Router<SettingsRoute, AppAlert>
typealias OnboardingRouter = Router<OnboardingRoute, AppAlert>

@Observable
final class Router<Route: AppRoute, Alert: Identifiable & Sendable>: @unchecked Sendable, RoutableNavigation {
    func navigate(to route: Route, style: NavigationStyle) {
        switch style {
        case .push:
            navigationPath.append(route)
        case .sheet(let detents):
            sheetItem = SheetItem(route: route, detents: detents)
        }
    }
    
    func navigateToWebView(_ webRoute: WebRoute) {
        navigationPath.append(webRoute)
    }
    
    var navigationPath = NavigationPath()
    var sheetItem: SheetItem<Route>?
    var alertItem: AppAlert?
    
    func popLast() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    func popToRoot() {
        navigationPath = NavigationPath()
    }
    
    func setRoot(_ route: Route) {
        navigationPath = NavigationPath()
        navigationPath.append(route)
    }
    
    func showAlert(_ alert: AppAlert) {
        alertItem = alert
    }
}
