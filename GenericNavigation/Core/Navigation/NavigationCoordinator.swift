import SwiftUI

protocol NavigationCoordinator: Observable {
    func navigate(to route: any AppRoute, style: NavigationStyle)
    func navigate(to route: any AppRoute, style: NavigationStyle, resetRoot: Bool)
    func navigate(to: RootTab)
    func navigateToWebView(_ webRoute: WebRoute)
    func showAlert(_ alert: AppAlert)
}

extension AppRouter: @preconcurrency NavigationCoordinator {
    @MainActor
    func navigate(to route: any AppRoute, style: NavigationStyle) {
        switch route {
        case let route as HomeRoute:
            handle(.home(route, style: style))
        case let route as ProfileRoute:
            handle(.profile(route, style: style))
        case let route as SearchRoute:
            handle(.search(route, style: style))
        case let route as SettingsRoute:
            handle(.settings(route, style: style))
        default:
            break
        }
    }
    
    @MainActor
    func navigate(to route: any AppRoute, style: NavigationStyle, resetRoot: Bool) {
        switch route {
        case let route as HomeRoute:
            handle(.home(route, style: style), resetRoot: resetRoot)
        case let route as ProfileRoute:
            handle(.profile(route, style: style), resetRoot: resetRoot)
        case let route as SearchRoute:
            handle(.search(route, style: style), resetRoot: resetRoot)
        case let route as SettingsRoute:
            handle(.settings(route, style: style), resetRoot: resetRoot)
        default:
            break
        }
    }
    
    @MainActor
    func navigate(to tab: RootTab) {
        handle(.rootTab(tab))
    }
    
    @MainActor
    func navigateToWebView(_ webRoute: WebRoute) {
        handle(.weblink(webRoute))
    }
    
    func showAlert(_ alert: AppAlert) {
        switch selectedTab {
        case .home:
            homeRouter.showAlert(alert)
        case .profile:
            profileRouter.showAlert(alert)
        case .search:
            searchRouter.showAlert(alert)
        case .settings:
            settingsRouter.showAlert(alert)
        }
    }
} 
