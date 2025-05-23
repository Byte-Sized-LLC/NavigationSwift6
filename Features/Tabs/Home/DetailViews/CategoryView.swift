//
//  CategoryView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct CategoryView: View {
    let categoryId: String
    
    var body: some View {
        Text("Category: \(categoryId)")
            .navigationTitle("Category")
    }
}
