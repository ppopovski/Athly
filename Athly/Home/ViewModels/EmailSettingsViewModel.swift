//
//  EmailSettingsViewModel.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

@Observable
class EmailSettingsViewModel {
    var currentEmail = "user@example.com"
    var newEmail = ""
    var password = ""
    var isLoading = false
    
    var isFormValid: Bool {
        !newEmail.isEmpty && newEmail.contains("@") && !password.isEmpty && newEmail != currentEmail
    }
    
    func updateEmail(onSuccess: @escaping () -> Void) {
        isLoading = true
        // TODO: Implement email update logic with Firebase
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            onSuccess()
        }
    }
}
