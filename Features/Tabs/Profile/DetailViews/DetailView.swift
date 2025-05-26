//
//  DetailView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct DetailView: View {
    let itemId: String
    @Environment(\.appRouter) private var appRouter
    
    var body: some View {
        VStack {
            Text("Detail View for item: \(itemId)")
                .navigationTitle("Detail")
            
            Button("Go to Category") {
                Task { @MainActor in
                    appRouter.homeRouter.navigate(to: .category(categoryId: "sample-category"), style: .push)
                }
            }
            .padding()
        }
    }
}
