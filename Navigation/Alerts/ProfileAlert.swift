//
//  ProfileAlert.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

struct ProfileAlert: Identifiable, Sendable {
    let id = UUID()
    let type: AlertType
    
    enum AlertType: Sendable {
        case logoutConfirmation
        case unsavedChanges
    }
}
