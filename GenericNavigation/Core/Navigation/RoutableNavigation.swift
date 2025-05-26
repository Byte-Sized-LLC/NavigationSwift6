//
//  RoutableNavigation.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/24/25.
//

import SwiftUI

protocol RoutableNavigation: ObservableObject {
    associatedtype Route: AppRoute
    
    var navigationPath: NavigationPath { get set }
    var sheetItem: SheetItem<Route>? { get set }
    var alertItem: AppAlert? { get set }

    func navigate(to route: Route, style: NavigationStyle)
    func popLast()
    func popToRoot()
    func navigateToWebView(_ webRoute: WebRoute)
}
