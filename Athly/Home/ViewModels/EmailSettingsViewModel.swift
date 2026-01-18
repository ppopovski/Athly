//
//  EmailSettingsViewModel.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

@MainActor
@Observable
class EmailSettingsViewModel {
    var newEmail = ""
    var password = ""
    var isLoading = false

    var currentEmail: String {
        AuthManager.shared.currentUser?.email ?? "Not signed in"
    }

    var isFormValid: Bool {
        !newEmail.isEmpty && newEmail.contains("@") && !password.isEmpty && newEmail != currentEmail
    }

    func updateEmail(onSuccess: @escaping () -> Void) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            onSuccess()
        }
    }
}
