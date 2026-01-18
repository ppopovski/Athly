//
//  ChangePasswordView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct ChangePasswordView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @Environment(\.dismiss) private var dismiss
    @Environment(ChangePasswordViewModel.self) private var viewModel

    var body: some View {
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    passwordFields
                    passwordRequirements
                    saveButton

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CustomColor.primary)
            }

            Spacer()
        }
        .padding(.top, 10)

        VStack(alignment: .leading, spacing: 8) {
            Text("Change Password")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(CustomColor.primary)

            Text("Update your account password")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.top, 10)
    }

    @ViewBuilder
    private var passwordFields: some View {
        @Bindable var viewModel = viewModel

        VStack(spacing: 16) {
            VStack(spacing: 12) {
                HStack {
                    Text("Current Password")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(CustomColor.primary)
                    Spacer()
                }

                CustomTextField(
                    title: "Enter current password",
                    text: $viewModel.currentPassword,
                    isSecure: true,
                    cornerRadius: 25,
                    placeholderColor: .white.opacity(0.5),
                    backgroundColor: CustomColor.bgBlack,
                    textColor: .white
                )
                .textContentType(.password)
            }

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
                    Text("Confirm New Password")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(CustomColor.primary)
                    Spacer()
                }

                CustomTextField(
                    title: "Re-enter new password",
                    text: $viewModel.confirmPassword,
                    isSecure: true,
                    cornerRadius: 25,
                    placeholderColor: .white.opacity(0.5),
                    backgroundColor: CustomColor.bgBlack,
                    textColor: .white
                )
                .textContentType(.newPassword)
            }
        }
    }

    @ViewBuilder
    private var passwordRequirements: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Password Requirements")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white.opacity(0.8))

            VStack(alignment: .leading, spacing: 8) {
                PasswordRequirementRow(text: "At least 8 characters", met: viewModel.meetsLengthRequirement)
                PasswordRequirementRow(text: "Passwords match", met: viewModel.passwordsMatch)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }



    @ViewBuilder
    private var saveButton: some View {
        CustomButton(
            buttonText: "Update Password",
            cornerRadius: ButtonCornerRadius,
            disabled: !viewModel.isFormValid,
            loading: viewModel.isLoading,
            buttonType: .primary
        ) {
            viewModel.updatePassword {
                dismiss()
            }
        }
    }
}

struct PasswordRequirementRow: View {
    let text: String
    let met: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: met ? "checkmark.circle.fill" : "circle")
                .foregroundColor(met ? CustomColor.primary : .white.opacity(0.3))
                .font(.system(size: 16))

            Text(text)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(met ? .white : .white.opacity(0.6))
        }
    }
}

#Preview {
    NavigationStack {
        ChangePasswordView()
            .environment(NavigationCoordinator())
    }
}
