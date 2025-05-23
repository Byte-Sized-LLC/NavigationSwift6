//
//  HomeSheet.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

enum HomeSheet: Identifiable, Sendable {
    case newItem
    case share(itemId: String)
    case quickAdd
    
    var id: String {
        switch self {
        case .newItem: return "home.sheet.newItem"
        case .share: return "home.sheet.share"
        case .quickAdd: return "home.sheet.quickAdd"
        }
    }
}
