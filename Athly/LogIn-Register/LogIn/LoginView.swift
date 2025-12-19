//
//  LogInView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @Bindable private var viewModel = LoginViewModel()
    @FocusState private var focused: LoginField?
    
    var body: some View {
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            VStack(spacing: 20) {
                backButton
                header
                formFields
                forgotPasswordButton
                Spacer()
                loginButton
                orDivider
                socialLoginButtons
                signUpPrompt
            }
            .padding()
            .background {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        dismissKeyboard()
                    }
            }
            .disabled(viewModel.callInprogress)
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
            Text("Welcome back!")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(CustomColor.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Please enter your details.")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, 20)
    }

    @ViewBuilder
    private var formFields: some View {
        VStack(spacing: 12) {
            VStack(spacing: 12) {
                HStack {
                    Text("Email")
                        .font(.system(size: 12, weight: .bold, design: .default))
                        .foregroundColor(CustomColor.primary)
                    Spacer()
                }

                CustomTextField(
                    title: "Enter your email",
                    text: $viewModel.email,
                    cornerRadius: 25,
                    descriptionText: false,
                    placeholderColor: .white.opacity(0.5),
                    backgroundColor: CustomColor.bgBlack,
                    textColor: .white
                )
                .focused($focused, equals: .email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .submitLabel(.next)
            }

            VStack(spacing: 12) {
                HStack {
                    Text("Password")
                        .font(.system(size: 12, weight: .bold, design: .default))
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
                .focused($focused, equals: .password)
                .keyboardType(.asciiCapable)
                .textContentType(.password)
                .submitLabel(.done)
            }
        }
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .scrollDisabled(true)
        .onTapGesture {
            dismissKeyboard()
        }
    }

    @ViewBuilder
    private var forgotPasswordButton: some View {
        HStack {
            Spacer()
            Button {
                coordinator.push(WelcomeScreen.forgotPassword)
            } label: {
                Text("Forgot Password?")
                    .font(.system(size: 14, weight: .bold, design: .default))
                    .foregroundColor(CustomColor.primary)
                    .underline()
            }
        }
    }

    @ViewBuilder
    private var loginButton: some View {
        CustomButton(
            buttonText: "Login",
            cornerRadius: ButtonCornerRadius,
            disabled: !viewModel.allDataEnteredCorrectly,
            buttonType: .primary
        ) {
            dismissKeyboard()
            login()
        }
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
        }
        .frame(height: 54)
    }

    @ViewBuilder
    private var signUpPrompt: some View {
        Button {
            coordinator.replace(with: WelcomeScreen.register)
        } label: {
            HStack {
                Text("Don't have an account?")
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundColor(CustomColor.bgWhite)

                Text("Sign up")
                    .font(.system(size: 14, weight: .bold, design: .default))
                    .foregroundColor(CustomColor.primary)
                    .underline()
            }
        }
    }

    private func login() {
        Task {
            await viewModel.login()
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
        LoginView()
            .environment(NavigationCoordinator())
    }
}

extension LoginView {
    enum LoginField {
        case email
        case password
    }
}
