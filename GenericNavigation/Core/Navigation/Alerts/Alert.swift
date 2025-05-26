//
//  Alert.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/24/25.
//

import Foundation
import SwiftUI

enum AppAlert: Hashable, Identifiable, Sendable, Equatable {
    var id: Self { self }

    case error(title: String, message: String)
    case info(title: String, message: String)
    
    var alert: Alert {
        switch self {
        case .error(let title, let message):
            return Alert(title: Text(title), message: Text(message))
        case .info(let title, let message):
            return Alert(title: Text(title), message: Text(message))
        }
    }
}
