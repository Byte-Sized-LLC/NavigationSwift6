//
//  NavigationViewWrapper.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/25/25.
//

import Foundation
import SwiftUI

struct NavigationViewWrapper<Content: View, Route: Hashable, SheetRoute: Hashable>: View {
    @Binding var navigationPath: [Route]
    @Binding var sheetItem: SheetItem<SheetRoute>?
    let content: Content
    let destinationBuilder: (Route) -> AnyView
    let sheetBuilder: (SheetRoute) -> AnyView
    
    init(
        navigationPath: Binding<[Route]>,
        sheetItem: Binding<SheetItem<SheetRoute>?>,
        @ViewBuilder content: () -> Content,
        @ViewBuilder destinationBuilder: @escaping (Route) -> some View,
        @ViewBuilder sheetBuilder: @escaping (SheetRoute) -> some View
    ) {
        self._navigationPath = navigationPath
        self._sheetItem = sheetItem
        self.content = content()
        self.destinationBuilder = { AnyView(destinationBuilder($0)) }
        self.sheetBuilder = { AnyView(sheetBuilder($0)) }
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            content
                .navigationDestination(for: Route.self) { route in
                    destinationBuilder(route)
                }
        }
        .sheet(item: $sheetItem) { sheet in
            sheetBuilder(sheet.route)
        }
    }
}
