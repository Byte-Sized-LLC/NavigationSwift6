//
//  User.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

struct User: Identifiable, Codable, Sendable {
    let id: String
    let name: String
    let email: String
    var profile: UserProfile?
}
