//
//  EditProfileView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct EditProfileView: View {
    @Bindable var viewModel: ProfileViewModel
    
    var body: some View {
        Text("Edit Profile")
            .navigationTitle("Edit Profile")
    }
}
