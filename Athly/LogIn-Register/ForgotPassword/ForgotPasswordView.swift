//
//  ForgotPasswordView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(ForgotPasswordViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var viewModel = viewModel
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
                Text("Forgot Password?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(CustomColor.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Don't worry! Enter your email address and we'll send you a verification code to reset your password.")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 20)
            
            Spacer()
                .frame(height: 40)
            
            // Email input
            VStack(spacing: 12) {
                HStack {
                    Text("Email Address")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(CustomColor.primary)
                    Spacer()
                }
                
                CustomTextField(
                    title: "Enter your email",
                    text: $viewModel.email,
                    cornerRadius: 25,
                    placeholderColor: .white.opacity(0.5),
                    backgroundColor: CustomColor.bgBlack,
                    textColor: .white,
                    inputValidator: .init(errorCases: [.empty, .email])
                )
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
            }
            
            Spacer()
            
            CustomButton(
                buttonText: "Send Verification Code",
                cornerRadius: ButtonCornerRadius,
                disabled: !viewModel.email.isValidEmail,
                buttonType: .primary
            ) {
                dismissKeyboard()
                viewModel.forgotPasswordState = .verificationCode
            }
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
            ForgotPasswordView()
                .environment(ForgotPasswordViewModel())
        }
    }
}

