//
//  DeleteAccountView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct DeleteAccountView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Delete Account")
                    .font(.largeTitle)
                Text("This action cannot be undone")
                    .foregroundColor(.red)
                
                Button("Delete Account") {
                    // Handle deletion
                }
                .foregroundColor(.red)
            }
            .navigationTitle("Delete Account")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
