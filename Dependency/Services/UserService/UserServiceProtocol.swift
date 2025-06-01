//
//  UserServiceProtocol.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

protocol UserServiceProtocol: Sendable {
    func fetchCurrentUser() async throws -> User
    func updateProfile(_ profile: UserProfile) async throws
}
