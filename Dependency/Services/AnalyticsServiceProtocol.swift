//
//  AnalyticsServiceProtocol.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation
import SwiftUI

protocol AnalyticsServiceProtocol: Sendable {
    func track(_ event: AnalyticsEvent) async
}

enum AnalyticsEvent: Sendable {
    case appLifecycle(ScenePhase)
    case screenView(String)
    case buttonTap(String)
    case custom(String, parameters: [String: String]?)
}
