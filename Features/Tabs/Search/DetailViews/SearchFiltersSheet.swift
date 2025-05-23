//
//  SearchFiltersSheet.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct SearchFiltersSheet: View {
    let filters: SearchFilters
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Text("Filter Options")
                .navigationTitle("Filters")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Apply") { dismiss() }
                    }
                }
        }
    }
}
