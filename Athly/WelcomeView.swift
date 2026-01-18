//
//  WelcomeView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct WelcomeView: View {
    @State private var coordinator = NavigationCoordinator()
    @State private var forgotPasswordViewModel = ForgotPasswordViewModel()

    var body: some View {
        switch AuthManager.shared.userState {
        case .loggedOut, .needsOnboarding:
            ZStack {
                CustomColor.bgBlack.ignoresSafeArea()

                NavigationStack(path: $coordinator.path) {
                    SplashView()
                        .navigationDestination(for: WelcomeScreen.self) { screen in
                            ZStack {
                                CustomColor.bgBlack.ignoresSafeArea()
                                WelcomeScreenView(screen: screen, forgotPasswordViewModel: forgotPasswordViewModel)
                            }
                            .background(CustomColor.bgBlack)
                        }
                        .toolbarBackground(CustomColor.bgBlack, for: .navigationBar)
                        .toolbarColorScheme(.dark, for: .navigationBar)
                }
                .environment(coordinator)
                .onChange(of: forgotPasswordViewModel.forgotPasswordState) { _, newValue in
                    switch newValue {
                    case .forgotPassword:
                        break
                    case .verificationCode:
                        coordinator.push(WelcomeScreen.verificationCode)
                    case .newPassword:
                        coordinator.push(WelcomeScreen.newPassword)
                    case .passwordChanged:
                        coordinator.push(WelcomeScreen.passwordChanged)
                    }
                }
            }
            .preferredColorScheme(.dark)
            .onAppear {
                coordinator.popToRoot()
            }
        case .authenticated:
            AuthenticatedView()
                .environment(coordinator)
                .onAppear {
                    coordinator.popToRoot()
                }
        }
    }

}

struct WelcomeScreenView: View {
    let screen: WelcomeScreen
    let forgotPasswordViewModel: ForgotPasswordViewModel

    var body: some View {
        switch screen {
        case .login:
            LoginView()
        case .register:
            RegisterView()
        case .forgotPassword:
            ForgotPasswordView()
                .environment(forgotPasswordViewModel)
        case .verificationCode:
            VerificationCodeView()
                .environment(forgotPasswordViewModel)
        case .newPassword:
            NewPasswordView()
                .environment(forgotPasswordViewModel)
        case .passwordChanged:
            PasswordChangedView()
                .environment(forgotPasswordViewModel)
        }
    }
}

#Preview {
    WelcomeView()
}
