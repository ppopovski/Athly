//
//  TermsOfServiceView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct TermsOfServiceView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    content

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
            Text("Terms of Service")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(CustomColor.primary)

            Text("Last updated: December 2025")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(.top, 10)
    }

    @ViewBuilder
    private var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            PolicySection(
                title: "1. Acceptance of Terms",
                text: "By accessing and using Athly, you accept and agree to be bound by the terms and provision of this agreement."
            )

            PolicySection(
                title: "2. Use License",
                text: "Permission is granted to use Athly for personal, non-commercial fitness tracking purposes. This license shall automatically terminate if you violate any of these restrictions."
            )

            PolicySection(
                title: "3. User Account",
                text: "You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account."
            )

            PolicySection(
                title: "4. User Content",
                text: "You retain all rights to your workout data and fitness information. By using Athly, you grant us a limited license to use this data to provide and improve our services."
            )

            PolicySection(
                title: "5. Prohibited Uses",
                text: "You may not use Athly for any illegal purposes or to violate any laws. You may not attempt to interfere with the proper functioning of the app."
            )

            PolicySection(
                title: "6. Disclaimer",
                text: "Athly is provided \"as is\" without warranties of any kind. We do not guarantee that the app will be error-free or uninterrupted. Always consult with a healthcare professional before starting any fitness program."
            )

            PolicySection(
                title: "7. Limitation of Liability",
                text: "In no event shall Athly be liable for any damages arising from the use or inability to use the app, including but not limited to injuries or health issues."
            )

            PolicySection(
                title: "8. Changes to Terms",
                text: "We reserve the right to modify these terms at any time. Continued use of Athly after changes constitutes acceptance of the new terms."
            )

            PolicySection(
                title: "9. Contact Information",
                text: "For questions about these Terms of Service, please contact us at legal@athly.com"
            )
        }
    }

}

struct PolicySection: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(CustomColor.primary)

            Text(text)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
    }
}

#Preview {
    NavigationStack {
        TermsOfServiceView()
            .environment(NavigationCoordinator())
    }
}
