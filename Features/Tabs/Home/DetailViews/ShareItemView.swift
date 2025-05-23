//
//  ShareItemView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct ShareItemView: View {
    let itemId: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Text("Share Item: \(itemId)")
                .navigationTitle("Share")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}
