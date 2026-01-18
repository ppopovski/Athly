//
//  SettingsView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(NavigationCoordinator.self) private var navigation

    var body: some View {
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    accountSection
                    appSettingsSection
                    aboutSection
                    logoutButton

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    @ViewBuilder
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Settings")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(CustomColor.primary)

            Text("Manage your account and preferences")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SettingsSectionTitle(title: "Account")

            VStack(spacing: 0) {

                SettingsRow(
                    icon: "envelope.fill",
                    title: "Email",
                    subtitle: AuthManager.shared.currentUser?.email ?? "Not signed in"
                ) {
                    navigation.push(HomeScreen.emailSettings)
                }

                Divider().background(Color.white.opacity(0.1))

                SettingsRow(
                    icon: "lock.fill",
                    title: "Change Password",
                    subtitle: "Update your password"
                ) {
                    navigation.push(HomeScreen.changePassword)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }
    
    @ViewBuilder
    private var appSettingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SettingsSectionTitle(title: "App Settings")

            VStack(spacing: 0) {
                SettingsRow(
                    icon: "chart.bar.fill",
                    title: "Units",
                    subtitle: "Metric"
                ) {
                    navigation.push(HomeScreen.unitsSettings)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }
    
    @ViewBuilder
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SettingsSectionTitle(title: "About")

            VStack(spacing: 0) {
                SettingsRow(
                    icon: "info.circle.fill",
                    title: "About Athly",
                    subtitle: "Version 1.0.0"
                ) {
                    navigation.push(HomeScreen.about)
                }

                Divider().background(Color.white.opacity(0.1))

                SettingsRow(
                    icon: "doc.text.fill",
                    title: "Privacy Policy",
                    subtitle: "Read our privacy policy"
                ) {
                    navigation.push(HomeScreen.privacyPolicy)
                }

                Divider().background(Color.white.opacity(0.1))

                SettingsRow(
                    icon: "doc.plaintext.fill",
                    title: "Terms of Service",
                    subtitle: "Read our terms"
                ) {
                    navigation.push(HomeScreen.termsOfService)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }
    
    @ViewBuilder
    private var logoutButton: some View {
        CustomButton(
            buttonText: "Log Out",
            cornerRadius: ButtonCornerRadius,
            image: Image(systemName: "rectangle.portrait.and.arrow.right"),
            backgroundColor: Color.red.opacity(0.1),
            contentsColor: .red,
            borderColor: .red.opacity(0.3),
            buttonType: .primary
        ) {
            // Dismiss keyboard before logout
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            withAnimation {
                do {
                    try AuthManager.shared.signOut()
                } catch {
                    print("Error signing out: \(error)")
                }
            }
        }
    }
}

struct SettingsSectionTitle: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.white.opacity(0.5))
            .textCase(.uppercase)
            .padding(.horizontal, 4)
    }
}

#Preview {
    SettingsView()
        .environment(NavigationCoordinator())
}
