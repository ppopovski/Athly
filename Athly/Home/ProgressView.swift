//
//  ProgressView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct ProgressView: View {
    @Environment(NavigationCoordinator.self) private var navigation
    @Environment(\.dismiss) private var dismiss
    @Environment(ProgressViewModel.self) private var viewModel

    var body: some View {
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    statsOverview
                    timeRangeSelector
                    workoutChart
                    categoryBreakdown
                    achievements

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
            Text("Your Progress")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(CustomColor.primary)

            Text("Track your fitness journey")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.top, 20)
    }

    @ViewBuilder
    private var statsOverview: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ProgressStatCard(
                    icon: "figure.strengthtraining.traditional",
                    title: "Workouts",
                    value: "\(viewModel.totalWorkouts)",
                    subtitle: "This month",
                    color: CustomColor.primary
                )

                ProgressStatCard(
                    icon: "flame.fill",
                    title: "Calories",
                    value: viewModel.totalCalories,
                    subtitle: "Total burned",
                    color: CustomColor.accent
                )
            }

            HStack(spacing: 12) {
                ProgressStatCard(
                    icon: "clock.fill",
                    title: "Total Time",
                    value: viewModel.totalTime,
                    subtitle: "This month",
                    color: CustomColor.link
                )

                ProgressStatCard(
                    icon: "trophy.fill",
                    title: "Streak",
                    value: "\(viewModel.currentStreak)",
                    subtitle: "Days",
                    color: CustomColor.success
                )
            }
        }
    }

    @ViewBuilder
    private var timeRangeSelector: some View {
        HStack(spacing: 12) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                TimeRangeTab(
                    title: range.rawValue,
                    isSelected: viewModel.selectedTimeRange == range
                ) {
                    withAnimation(.spring(response: 0.3)) {
                        viewModel.changeTimeRange(to: range)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var workoutChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Workout Frequency")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            VStack(spacing: 8) {
                ForEach(viewModel.chartData, id: \.day) { data in
                    HStack(spacing: 12) {
                        Text(data.day)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 40, alignment: .leading)

                        GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(CustomColor.primary)
                                .frame(width: CGFloat(data.workouts) / 5.0 * geometry.size.width)
                        }
                        .frame(height: 24)

                        Text("\(data.workouts)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(CustomColor.primary)
                            .frame(width: 30, alignment: .trailing)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }

    @ViewBuilder
    private var categoryBreakdown: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Workout Types")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            VStack(spacing: 12) {
                ForEach(viewModel.categoryData, id: \.title) { category in
                    CategoryProgressBar(
                        icon: category.icon,
                        title: category.title,
                        workouts: category.workouts,
                        total: category.total,
                        color: category.color
                    )
                }
            }
        }
    }

    @ViewBuilder
    private var achievements: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Achievements")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            VStack(spacing: 12) {
                ForEach(viewModel.achievements, id: \.title) { achievement in
                    AchievementCard(
                        icon: achievement.icon,
                        title: achievement.title,
                        description: achievement.description,
                        color: achievement.color
                    )
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProgressView()
    }
    .environment(NavigationCoordinator())
    .environment(ProgressViewModel())
}
