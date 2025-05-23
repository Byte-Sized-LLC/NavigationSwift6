//
//  FollowersView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct FollowersView: View {
    let userId: String
    
    var body: some View {
        Text("Followers of \(userId)")
            .navigationTitle("Followers")
    }
}
