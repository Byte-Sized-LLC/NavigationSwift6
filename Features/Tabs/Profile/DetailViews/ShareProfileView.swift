//
//  ShareProfileView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct ShareProfileView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Text("ShareProfileView")
                .navigationTitle("ShareProfileView")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}
