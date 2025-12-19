//
//  RegisterView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI
import AuthenticationServices

struct RegisterView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @Bindable private var viewModel = RegisterViewModel()
    @FocusState private var focused: RegisterField?

    @State private var email = ""
    @State private var confirmEmail = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    var body: some View {
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    backButton
                    header
                    formFields
                    signUpButton
                    orDivider
                    socialLoginButtons
                    loginPrompt
                }
                .padding()
            }
            .background {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        dismissKeyboard()
                    }
            }
        }
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private var backButton: some View {
        HStack {
            Button {
                coordinator.pop()
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
    }

    @ViewBuilder
    private var header: some View {
        VStack(spacing: 8) {
            Text("Create Account")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(CustomColor.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Please enter your details to sign up.")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, 20)
    }

    @ViewBuilder
    private var formFields: some View {
        VStack(spacing: 25) {
            fieldSection(
                label: "Email Address",
                placeholder: "Enter Your Email",
                text: $email,
                field: .email,
                keyboardType: .emailAddress,
                contentType: .emailAddress,
                submitLabel: .next
            )

            fieldSection(
                label: "Confirm Email",
                placeholder: "Confirm Your Email",
                text: $confirmEmail,
                field: .confirmEmail,
                keyboardType: .emailAddress,
                contentType: .emailAddress,
                submitLabel: .next
            )

            fieldSection(
                label: "Password",
                placeholder: "Enter Your Password",
                text: $password,
                field: .password,
                isSecure: true,
                keyboardType: .asciiCapable,
                contentType: .newPassword,
                submitLabel: .next
            )

            fieldSection(
                label: "Confirm Password",
                placeholder: "Confirm Your Password",
                text: $confirmPassword,
                field: .confirmPassword,
                isSecure: true,
                keyboardType: .asciiCapable,
                contentType: .newPassword,
                submitLabel: .done
            )
        }
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
    }

    @ViewBuilder
    private func fieldSection(
        label: String,
        placeholder: String,
        text: Binding<String>,
        field: RegisterField,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType,
        contentType: UITextContentType,
        submitLabel: SubmitLabel
    ) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text(label)
                    .font(.system(size: 12, weight: .bold, design: .default))
                    .foregroundColor(CustomColor.primary)
                Spacer()
            }

            CustomTextField(
                title: placeholder,
                text: text,
                isSecure: isSecure,
                cornerRadius: 25,
                descriptionText: false,
                placeholderColor: .white.opacity(0.5),
                backgroundColor: CustomColor.bgBlack,
                textColor: .white
            )
            .focused($focused, equals: field)
            .keyboardType(keyboardType)
            .textContentType(contentType)
            .submitLabel(submitLabel)
        }
    }

    @ViewBuilder
    private var signUpButton: some View {
        CustomButton(
            buttonText: "Sign Up",
            cornerRadius: ButtonCornerRadius,
            disabled: !isFormValid,
            buttonType: .primary
        ) {
            dismissKeyboard()
            register()
        }
        .padding(.top, 10)
    }

    @ViewBuilder
    private var orDivider: some View {
        HStack {
            Rectangle()
                .fill(CustomColor.primary.opacity(0.3))
                .frame(height: 1)

            Text("or")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white)
                .padding(.horizontal, 12)

            Rectangle()
                .fill(CustomColor.primary.opacity(0.3))
                .frame(height: 1)
        }
        .padding(.vertical, 10)
    }

    @ViewBuilder
    private var socialLoginButtons: some View {
        HStack(spacing: 12) {
            CustomButton(
                buttonText: "",
                cornerRadius: ButtonCornerRadius,
                image: Image(systemName: "apple.logo"),
                backgroundColor: CustomColor.primary,
                contentsColor: .white,
                buttonType: .primary
            ) {
                handleAppleSignIn()
            }

            CustomButton(
                buttonText: "",
                cornerRadius: ButtonCornerRadius,
                image: Image(systemName: "g.circle.fill"),
                backgroundColor: CustomColor.primary,
                contentsColor: .white,
                buttonType: .primary
            ) {
                handleGoogleSignIn()
            }
            .frame(height: 54)
        }
        .frame(height: 54)
    }

    @ViewBuilder
    private var loginPrompt: some View {
        Button {
            coordinator.replace(with: WelcomeScreen.login)
        } label: {
            HStack {
                Text("Already have an account?")
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundColor(CustomColor.bgWhite)

                Text("Log in")
                    .font(.system(size: 14, weight: .bold, design: .default))
                    .foregroundColor(CustomColor.primary)
                    .underline()
            }
        }
        .padding(.top, 10)
    }

    private var isFormValid: Bool {
        !email.isEmpty &&
        !confirmEmail.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        email == confirmEmail &&
        password == confirmPassword &&
        email.contains("@") &&
        password.count >= 6
    }

    private func register() {
        Task {
            await viewModel.register(email: email, password: password)
        }
    }

    private func handleAppleSignIn() {
        print("Apple Sign In tapped")
    }

    private func handleGoogleSignIn() {
        print("Google Sign In tapped")
    }
}

#Preview {
    NavigationStack {
        RegisterView()
            .environment(NavigationCoordinator())
    }
}

extension RegisterView {
    enum RegisterField {
        case email
        case confirmEmail
        case password
        case confirmPassword
    }
}
