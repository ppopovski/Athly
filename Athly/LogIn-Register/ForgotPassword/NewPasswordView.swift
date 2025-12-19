//
//  NewPasswordView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct NewPasswordView: View {
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
                Text("Create New Password")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(CustomColor.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Your new password must be different from previously used passwords.")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 20)
            
            Spacer()
                .frame(height: 40)
            
            // Password inputs
            VStack(spacing: 16) {
                VStack(spacing: 12) {
                    HStack {
                        Text("New Password")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(CustomColor.primary)
                        Spacer()
                    }
                    
                    CustomTextField(
                        title: "Enter new password",
                        text: $viewModel.newPassword,
                        isSecure: true,
                        cornerRadius: 25,
                        placeholderColor: .white.opacity(0.5),
                        backgroundColor: CustomColor.bgBlack,
                        textColor: .white
                    )
                    .textContentType(.newPassword)
                }
                
                VStack(spacing: 12) {
                    HStack {
                        Text("Confirm Password")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(CustomColor.primary)
                        Spacer()
                    }
                    
                    CustomTextField(
                        title: "Re-enter new password",
                        text: $viewModel.newPasswordConfirm,
                        isSecure: true,
                        cornerRadius: 25,
                        placeholderColor: .white.opacity(0.5),
                        backgroundColor: CustomColor.bgBlack,
                        textColor: .white
                    )
                    .textContentType(.newPassword)
                }
            }
            
            Spacer()
            
            CustomButton(
                buttonText: "Reset Password",
                cornerRadius: ButtonCornerRadius,
                disabled: viewModel.newPassword.isEmpty ||
                         viewModel.newPasswordConfirm.isEmpty ||
                         viewModel.newPassword != viewModel.newPasswordConfirm,
                buttonType: .primary
            ) {
                dismissKeyboard()
                viewModel.forgotPasswordState = .passwordChanged
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
            NewPasswordView()
                .environment(ForgotPasswordViewModel())
        }
    }
}
