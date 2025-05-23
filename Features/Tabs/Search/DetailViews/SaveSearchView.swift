//
//  SaveSearchView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct SaveSearchView: View {
    let query: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Save Search: \(query)")
            Button("Save") { dismiss() }
        }
        .padding()
    }
}
