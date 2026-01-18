//
//  LogInViewModel.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI
import FirebaseAuth

@MainActor
@Observable class LoginViewModel {
    var email = ""
    var password = ""
    var callInprogress = false
    var errorMessage: String?

    var allDataEnteredCorrectly: Bool {
        return !email.isEmpty && !password.isEmpty && email.contains("@")
    }

    func login() async {
        guard allDataEnteredCorrectly else { return }

        callInprogress = true
        errorMessage = nil

        do {
            _ = try await Auth.auth().signIn(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
            
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
            case AuthErrorCode.userNotFound.rawValue:
                return "No account found with this email"
            case AuthErrorCode.wrongPassword.rawValue:
                return "Incorrect password"
            case AuthErrorCode.networkError.rawValue:
                return "Network error. Please check your connection"
            case AuthErrorCode.tooManyRequests.rawValue:
                return "Too many attempts. Please try again later"
            default:
                return "Login failed. Please try again"
            }
        }
        return "An unexpected error occurred"
    }
}

