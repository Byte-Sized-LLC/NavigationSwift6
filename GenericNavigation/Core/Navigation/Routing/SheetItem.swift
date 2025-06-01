//
//  SheetItem.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/24/25.
//

import SwiftUI

struct SheetItem<Route: Hashable>: Identifiable {
    let id = UUID()
    let route: Route
    let detents: Set<PresentationDetent>
}
