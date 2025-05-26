//
//  DeepLink.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

enum DeepLink: Equatable, Sendable {
    case profile(userId: String)
    case item(itemId: String)
    case search(query: String?)
    case settings
}
