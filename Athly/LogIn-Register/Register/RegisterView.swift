//
//  RegisterView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct RegisterView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @Bindable private var viewModel = RegisterViewModel()
    @FocusState private var focused: RegisterField?

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
        .onAppear {
            dismissKeyboard()
            focused = nil
        }
        .alert(
            "Error",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { isPresented in
                    if !isPresented {
                        viewModel.errorMessage = nil
                    }
                }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
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
            RegisterFieldSection(
                config: .init(
                    label: "Email Address",
                    placeholder: "Enter Your Email",
                    field: .email,
                    isSecure: false,
                    keyboardType: .emailAddress,
                    contentType: .emailAddress,
                    submitLabel: .next
                ),
                text: $viewModel.email,
                focus: $focused
            )

            RegisterFieldSection(
                config: .init(
                    label: "Confirm Email",
                    placeholder: "Confirm Your Email",
                    field: .confirmEmail,
                    isSecure: false,
                    keyboardType: .emailAddress,
                    contentType: .emailAddress,
                    submitLabel: .next
                ),
                text: $viewModel.confirmEmail,
                focus: $focused
            )

            RegisterFieldSection(
                config: .init(
                    label: "Password",
                    placeholder: "Enter Your Password",
                    field: .password,
                    isSecure: true,
                    keyboardType: .asciiCapable,
                    contentType: .newPassword,
                    submitLabel: .next
                ),
                text: $viewModel.password,
                focus: $focused
            )

            RegisterFieldSection(
                config: .init(
                    label: "Confirm Password",
                    placeholder: "Confirm Your Password",
                    field: .confirmPassword,
                    isSecure: true,
                    keyboardType: .asciiCapable,
                    contentType: .newPassword,
                    submitLabel: .done
                ),
                text: $viewModel.confirmPassword,
                focus: $focused
            )
        }
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
    }

    @ViewBuilder
    private var signUpButton: some View {
        CustomButton(
            buttonText: "Sign Up",
            cornerRadius: ButtonCornerRadius,
            disabled: !viewModel.allDataEnteredCorrectly,
            buttonType: .primary
        ) {
            dismissKeyboard()
            Task {
                await viewModel.register()
            }
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
                dismissKeyboard()
                focused = nil
                Task {
                    await viewModel.signInWithApple()
                }
            }

            CustomButton(
                buttonText: "",
                cornerRadius: ButtonCornerRadius,
                image: Image(systemName: "g.circle.fill"),
                backgroundColor: CustomColor.primary,
                contentsColor: .white,
                buttonType: .primary
            ) {
                dismissKeyboard()
                focused = nil
                Task {
                    await viewModel.signInWithGoogle()
                }
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


}

#Preview {
    NavigationStack {
        RegisterView()
            .environment(NavigationCoordinator())
    }
}

enum RegisterField {
    case email
    case confirmEmail
    case password
    case confirmPassword
}

struct RegisterFieldSection: View {
    let config: RegisterFieldConfig
    @Binding var text: String
    let focus: FocusState<RegisterField?>.Binding

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(config.label)
                    .font(.system(size: 12, weight: .bold, design: .default))
                    .foregroundColor(CustomColor.primary)
                Spacer()
            }

            CustomTextField(
                title: config.placeholder,
                text: $text,
                isSecure: config.isSecure,
                cornerRadius: 25,
                descriptionText: false,
                placeholderColor: .white.opacity(0.5),
                backgroundColor: CustomColor.bgBlack,
                textColor: .white
            )
            .focused(focus, equals: config.field)
            .keyboardType(config.keyboardType)
            .textContentType(config.contentType)
            .submitLabel(config.submitLabel)
        }
    }
}

struct RegisterFieldConfig {
    let label: String
    let placeholder: String
    let field: RegisterField
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    let contentType: UITextContentType
    let submitLabel: SubmitLabel
}
