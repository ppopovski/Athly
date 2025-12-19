//
//  LogInViewModel.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

@MainActor
@Observable class LoginViewModel {

    var email = ""
    var password = ""

    var callInprogress = false

    var allDataEnteredCorrectly: Bool {
        return !email.isEmpty && !password.isEmpty
    }
    
    func login() async {
        callInprogress = true

        // Simulate API call delay
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

        // For now, accept any email and password
        // TODO: Replace with Firebase authentication
        withAnimation {
            AuthManager.shared.userState = .authenticated
        }

        callInprogress = false
    }
}

