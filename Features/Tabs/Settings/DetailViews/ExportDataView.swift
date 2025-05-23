//
//  ExportDataView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct ExportDataView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Text("Export Your Data")
                .navigationTitle("Export Data")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Export") { dismiss() }
                    }
                }
        }
    }
}

