//
//  PrivacyPolicyView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct PrivacyPolicyView: View {
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
            Text("Privacy Policy")
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
            section(
                title: "1. Information We Collect",
                text: "We collect information you provide directly to us, including your name, email address, workout data, and fitness goals. We also collect usage information about how you interact with our app."
            )

            section(
                title: "2. How We Use Your Information",
                text: "We use the information we collect to provide, maintain, and improve our services, to develop new features, to protect Athly and our users, and to communicate with you."
            )

            section(
                title: "3. Information Sharing",
                text: "We do not share your personal information with third parties except as described in this privacy policy. We may share your information with service providers who help us operate our business."
            )

            section(
                title: "4. Data Security",
                text: "We take reasonable measures to help protect your personal information from loss, theft, misuse, unauthorized access, disclosure, alteration, and destruction."
            )

            section(
                title: "5. Your Rights",
                text: "You have the right to access, update, or delete your personal information at any time. You can do this through your account settings or by contacting us directly."
            )

            section(
                title: "6. Changes to This Policy",
                text: "We may update this privacy policy from time to time. We will notify you of any changes by posting the new privacy policy on this page and updating the \"Last updated\" date."
            )

            section(
                title: "7. Contact Us",
                text: "If you have any questions about this privacy policy, please contact us at privacy@athly.com"
            )
        }
    }

    @ViewBuilder
    private func section(title: String, text: String) -> some View {
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
        PrivacyPolicyView()
            .environment(NavigationCoordinator())
    }
}
