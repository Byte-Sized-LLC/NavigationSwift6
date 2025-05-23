//
//  ProfileSheet.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

enum ProfileSheet: Identifiable, Sendable {
    case editProfile
    case changePhoto
    case shareProfile
    
    var id: String {
        switch self {
        case .editProfile: return "profile.sheet.edit"
        case .changePhoto: return "profile.sheet.photo"
        case .shareProfile: return "profile.sheet.share"
        }
    }
}
