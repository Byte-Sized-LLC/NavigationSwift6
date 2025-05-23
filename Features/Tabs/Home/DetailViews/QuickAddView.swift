//
//  QuickAddView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct QuickAddView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Quick Add")
            Button("Add") { dismiss() }
        }
        .padding()
    }
}

