//
//  NotificationsSettingsView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct NotificationsSettingsView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @Environment(\.dismiss) private var dismiss
    @Environment(NotificationsSettingsViewModel.self) private var viewModel

    var body: some View {
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    workoutNotifications
                    progressNotifications
                    socialNotifications

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
            Text("Notifications")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(CustomColor.primary)

            Text("Manage your notification preferences")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private var workoutNotifications: some View {
        VStack(alignment: .leading, spacing: 12) {
            @Bindable var viewModel = viewModel
            
            sectionTitle("Workout Notifications")

            VStack(spacing: 0) {
                toggleRow(
                    icon: "bell.fill",
                    title: "Workout Reminders",
                    subtitle: "Get reminded about scheduled workouts",
                    isOn: $viewModel.workoutReminders
                )

                Divider().background(Color.white.opacity(0.1))

                toggleRow(
                    icon: "chart.bar.fill",
                    title: "Progress Updates",
                    subtitle: "Weekly progress summaries",
                    isOn: $viewModel.progressUpdates
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }
    
    @ViewBuilder
    private var progressNotifications: some View {
        VStack(alignment: .leading, spacing: 12) {
            @Bindable var viewModel = viewModel
            
            sectionTitle("Progress & Achievements")

            VStack(spacing: 0) {
                toggleRow(
                    icon: "trophy.fill",
                    title: "Achievements",
                    subtitle: "Celebrate your milestones",
                    isOn: $viewModel.achievements
                )

                Divider().background(Color.white.opacity(0.1))

                toggleRow(
                    icon: "calendar",
                    title: "Weekly Reports",
                    subtitle: "Summary of your weekly activity",
                    isOn: $viewModel.weeklyReports
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }
    
    @ViewBuilder
    private var socialNotifications: some View {
        @Bindable var viewModel = viewModel
        
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Social")

            VStack(spacing: 0) {
                toggleRow(
                    icon: "person.2.fill",
                    title: "Social Activity",
                    subtitle: "Friend requests and activity",
                    isOn: $viewModel.socialActivity
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }
    
    @ViewBuilder
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.white.opacity(0.5))
            .textCase(.uppercase)
            .padding(.horizontal, 4)
    }

    @ViewBuilder
    private func toggleRow(icon: String, title: String, subtitle: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(CustomColor.primary)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(CustomColor.primary)
        }
        .padding(16)
    }
}

#Preview {
    NavigationStack {
        NotificationsSettingsView()
            .environment(NavigationCoordinator())
    }
}
