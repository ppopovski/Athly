//
//  RegisterViewModel.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

@MainActor
@Observable class RegisterViewModel {
    var username = ""
    var email = ""
    var password = ""
    
    var callInprogress = false
    
    var allDataEnteredCorrectly: Bool {
        return !username.isEmpty && !email.isEmpty && !password.isEmpty && email.isValidEmail
    }
    
    func register() async {
        callInprogress = true
        do {
//            let response = try await ApiClient.shared.client.api.auth.signUp(input: .init(email: email, password: password, profileType: .player))
            // make register call here
            withAnimation {
                AuthManager.shared.userState = .needsOnboarding
            }
        } catch {
            print("Error: \(error.localizedDescription)")
            callInprogress = false
        }
    }

    func register(email: String, password: String) async {
        self.email = email
        self.password = password
        callInprogress = true
        do {
//            let response = try await ApiClient.shared.client.api.auth.signUp(input: .init(email: email, password: password, profileType: .player))
            // make register call here
            withAnimation {
                AuthManager.shared.userState = .authenticated
            }
        } catch {
            print("Error: \(error.localizedDescription)")
            callInprogress = false
        }
    }
}

