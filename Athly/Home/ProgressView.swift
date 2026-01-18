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
                VStack(alignment: .leading, spacing: 32) {
                    header
                    statsOverview
                    timeRangeSelector
                    workoutChart
                    categoryBreakdown

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadWorkouts()
        }
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
        
        VStack(alignment: .leading, spacing: 12) {
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
        let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)
        
        LazyVGrid(columns: columns, spacing: 12) {
            ProgressStatCard(
                icon: "figure.strengthtraining.traditional",
                title: "Workouts",
                value: "\(viewModel.totalWorkouts)",
                subtitle: "This month",
                color: CustomColor.primary
            )
            
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

    @ViewBuilder
    private var timeRangeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(TimeRange.allCases, id: \.self) { range in
                    TimeRangeTab(
                        title: range.rawValue,
                        isSelected: viewModel.selectedTimeRange == range
                    ) {
                        withAnimation(.snappy) {
                            viewModel.changeTimeRange(to: range)
                        }
                    }
                }
            }
            .padding(.horizontal, 2)
        }
    }

    @ViewBuilder
    private var workoutChart: some View {
        let maxWorkouts = max(viewModel.chartData.map { $0.workouts }.max() ?? 1, 1)

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
                            .frame(width: 56, alignment: .leading)

                        GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(CustomColor.primary)
                                .frame(width: CGFloat(data.workouts) / CGFloat(maxWorkouts) * geometry.size.width)
                                .animation(.snappy, value: data.workouts)
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

            if viewModel.categoryData.isEmpty {
                emptyCategoryState
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.categoryData) { category in
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
    }

    @ViewBuilder
    private var emptyCategoryState: some View {
        VStack(spacing: 12) {
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(.white.opacity(0.3))

            Text("No workout types yet")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.03))
        )
    }
}

#Preview {
    NavigationStack {
        ProgressView()
    }
    .environment(NavigationCoordinator())
    .environment(ProgressViewModel())
}
