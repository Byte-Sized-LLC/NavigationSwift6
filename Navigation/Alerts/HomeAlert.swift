//
//  HomeAlert.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

struct HomeAlert: Identifiable, Sendable {
    let id = UUID()
    let type: AlertType
    
    enum AlertType: Sendable {
        case deleteItem(itemId: String)
        case error(message: String)
    }
}
