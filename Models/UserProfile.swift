//
//  UserProfile.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

struct UserProfile: Codable, Sendable {
    var name: String
    var bio: String?
    var avatarURL: String?
}
