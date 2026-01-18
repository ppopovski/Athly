//
//  AboutView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct AboutView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    appInfo
                    featuresSection
                    contactSection

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

        VStack(spacing: 16) {
            Image(.athlyLogo)
                .resizable()
                .frame(width: 80, height: 90)

            Text("Athly")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(CustomColor.primary)

            Text("Version 1.0.0")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 10)
    }

    @ViewBuilder
    private var appInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Athly is your ultimate workout tracking companion. Track your progress, plan your workouts, and achieve your fitness goals.")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }

    @ViewBuilder
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Features")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white.opacity(0.5))
                .textCase(.uppercase)
                .padding(.horizontal, 4)

            VStack(alignment: .leading, spacing: 16) {
                FeatureRow(icon: "figure.strengthtraining.traditional", text: "Track your workouts")
                FeatureRow(icon: "calendar", text: "Schedule and plan")
                FeatureRow(icon: "chart.bar.fill", text: "Monitor progress")
                FeatureRow(icon: "target", text: "Set and achieve goals")
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }


    @ViewBuilder
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Contact")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white.opacity(0.5))
                .textCase(.uppercase)
                .padding(.horizontal, 4)

            VStack(alignment: .leading, spacing: 12) {
                Text("Email: support@athly.com")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))

                Text("Website: www.athly.com")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(CustomColor.primary)
                .frame(width: 32)

            Text(text)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    NavigationStack {
        AboutView()
            .environment(NavigationCoordinator())
    }
}
