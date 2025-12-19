//
//  VerificationCodeView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct VerificationCodeView: View {
    @Environment(ForgotPasswordViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(CustomColor.primary)
                }
                Spacer()
            }
            .padding(.top, 10)
            
            VStack(spacing: 8) {
                Text("Verification Code")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(CustomColor.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("We've sent a verification code to")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(viewModel.email)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CustomColor.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 20)
            
            Spacer()
                .frame(height: 20)
            
            CustomConfirmationCodeView {
                // Resend action
                print("Resend code requested")
            } onSubmit: { confirmationCode in
                if viewModel.sendConfirmationCode(code: confirmationCode) {
                    viewModel.forgotPasswordState = .newPassword
                    return true
                }
                return false
            }
            
            Spacer()
        }
        .padding()
        .background {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    dismissKeyboard()
                }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()
            VerificationCodeView()
                .environment(ForgotPasswordViewModel())
        }
    }
}
