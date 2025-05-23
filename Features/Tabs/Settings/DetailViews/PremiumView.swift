//
//  PremiumView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct PremiumView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.yellow)
                
                Text("Go Premium")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Button("Subscribe") {
                    // Handle subscription
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Premium")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

