//
//  RegisterViewModel.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI
import FirebaseAuth

@MainActor
@Observable class RegisterViewModel {
    var username = ""
    var email = ""
    var confirmEmail = ""
    var password = ""
    var confirmPassword = ""

    var callInprogress = false
    var errorMessage: String?

    var allDataEnteredCorrectly: Bool {
        return !username.isEmpty &&
        !email.isEmpty &&
        !confirmEmail.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        email == confirmEmail &&
        password == confirmPassword &&
        email.isValidEmail &&
        password.count >= 6
    }

    func register() async {
        guard allDataEnteredCorrectly else { return }

        callInprogress = true
        errorMessage = nil

        do {
            let authResult = try await Auth.auth().createUser(
                withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )
            
            let changeRequest = authResult.user.createProfileChangeRequest()
            changeRequest.displayName = username
            try? await changeRequest.commitChanges()
            
            callInprogress = false
        } catch {
            callInprogress = false
            errorMessage = getErrorMessage(from: error)
        }
    }

    func signInWithApple() async {
        callInprogress = true
        errorMessage = nil

        do {
            _ = try await SocialAuthHelper.shared.signInWithApple()
            callInprogress = false
        } catch {
            callInprogress = false
            errorMessage = "Apple Sign In failed. Please try again."
        }
    }

    func signInWithGoogle() async {
        callInprogress = true
        errorMessage = nil

        do {
            _ = try await SocialAuthHelper.shared.signInWithGoogle()
            callInprogress = false
        } catch {
            callInprogress = false
            errorMessage = "Google Sign In failed. Please try again."
        }
    }

    private func getErrorMessage(from error: Error) -> String {
        if let authError = error as NSError? {
            switch authError.code {
            case AuthErrorCode.invalidEmail.rawValue:
                return "Invalid email address"
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                return "An account with this email already exists"
            case AuthErrorCode.weakPassword.rawValue:
                return "Password is too weak. Please use at least 6 characters"
            case AuthErrorCode.networkError.rawValue:
                return "Network error. Please check your connection"
            default:
                return "Registration failed. Please try again"
            }
        }
        return "An unexpected error occurred"
    }
}

