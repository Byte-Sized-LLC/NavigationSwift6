//
//  NavigationStyle.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/24/25.
//

import Foundation
import SwiftUI

enum NavigationStyle: Equatable {
    case push
    case sheet(detents: Set<PresentationDetent> = [.large])
}
