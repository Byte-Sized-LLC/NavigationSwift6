//
//  SettingsSheet.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

enum SettingsSheet: Identifiable, Sendable {
    case premium
    case exportData
    case deleteAccount
    
    var id: String {
        switch self {
        case .premium: return "settings.sheet.premium"
        case .exportData: return "settings.sheet.export"
        case .deleteAccount: return "settings.sheet.delete"
        }
    }
}
