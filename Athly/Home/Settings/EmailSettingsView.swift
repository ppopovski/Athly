//
//  EmailSettingsView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct EmailSettingsView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @Environment(\.dismiss) private var dismiss
    @Environment(EmailSettingsViewModel.self) private var viewModel

    var body: some View {
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    currentEmailSection
                    changeEmailForm
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
            Text("Email Settings")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(CustomColor.primary)

            Text("Update your email address")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private var currentEmailSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Current Email")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(CustomColor.primary)

            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundColor(CustomColor.primary)

                Text(viewModel.currentEmail)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(CustomColor.primary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }
    
    @ViewBuilder
    private var changeEmailForm: some View {
        @Bindable var viewModel = viewModel
        
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                HStack {
                    Text("New Email Address")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(CustomColor.primary)
                    Spacer()
                }

                CustomTextField(
                    title: "Enter new email",
                    text: $viewModel.newEmail,
                    cornerRadius: 25,
                    descriptionText: false,
                    placeholderColor: .white.opacity(0.5),
                    backgroundColor: CustomColor.bgBlack,
                    textColor: .white
                )
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            }

            VStack(spacing: 12) {
                HStack {
                    Text("Confirm Password")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(CustomColor.primary)
                    Spacer()
                }

                CustomTextField(
                    title: "Enter your password",
                    text: $viewModel.password,
                    isSecure: true,
                    cornerRadius: 25,
                    placeholderColor: .white.opacity(0.5),
                    backgroundColor: CustomColor.bgBlack,
                    textColor: .white
                )
                .textContentType(.password)
            }
        }
    }
    
    @ViewBuilder
    private var saveButton: some View {
        CustomButton(
            buttonText: "Update Email",
            cornerRadius: ButtonCornerRadius,
            disabled: !viewModel.isFormValid,
            loading: viewModel.isLoading,
            buttonType: .primary
        ) {
            viewModel.updateEmail {
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        EmailSettingsView()
            .environment(NavigationCoordinator())
    }
}
