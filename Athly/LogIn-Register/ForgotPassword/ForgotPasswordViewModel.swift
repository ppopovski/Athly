//
//  ForgotPasswordViewModel.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

enum ForgotPasswordState: Hashable {
    case forgotPassword
    case verificationCode
    case newPassword
    case passwordChanged
}

@MainActor
@Observable class ForgotPasswordViewModel {
    var forgotPasswordState: ForgotPasswordState = .forgotPassword

    var email = ""
    var newPassword = ""
    var newPasswordConfirm = ""

    func sendConfirmationCode(code: String) -> Bool {
        // Accept both "123456" and "000000" for testing/bypass
        return code == "123456" || code == "000000"
    }
}
