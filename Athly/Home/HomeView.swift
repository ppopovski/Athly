//
//  HomeView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct HomeView: View {
    @Environment(NavigationCoordinator.self) private var navigation
    @Environment(HomeViewModel.self) private var viewModel
    @Environment(AllWorkoutsViewModel.self) private var allWorkoutsViewModel

    var body: some View {
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    header
                    todaysWorkoutSection
                    recentWorkoutsSection
                    quickActionsSection

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
            }
        }
        .onAppear {
            allWorkoutsViewModel.loadWorkouts()
        }
    }

    @ViewBuilder
    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Welcome Back!")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(CustomColor.primary)

            Text(viewModel.currentDateString)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.top, 20)
    }

    @ViewBuilder
    private var todaysWorkoutSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Today's Workout")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)

            if let workout = allWorkoutsViewModel.todaysWorkout {
                WorkoutCard(
                    title: workout.title,
                    exercises: workout.exercises,
                    time: workout.time,
                    isCompleted: workout.isCompleted
                ) {
                    withAnimation(.snappy) {
                        navigation.push(HomeScreen.workoutDetail(workout))
                    }
                }
            } else {
                emptyWorkoutState
            }
        }
    }
    
    @ViewBuilder
    private var recentWorkoutsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Recent Workouts")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Button {
                    withAnimation(.snappy) {
                        navigation.push(HomeScreen.allWorkouts)
                    }
                } label: {
                    Text("View All")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CustomColor.primary)
                }
            }

            if allWorkoutsViewModel.recentWorkouts.isEmpty {
                emptyRecentState
            } else {
                VStack(spacing: 12) {
                    ForEach(allWorkoutsViewModel.recentWorkouts) { workout in
                        WorkoutCard(
                            title: workout.title,
                            exercises: workout.exercises,
                            time: workout.time,
                            isCompleted: workout.isCompleted,
                            date: workout.date
                        ) {
                            withAnimation(.snappy) {
                                navigation.push(HomeScreen.workoutDetail(workout))
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Quick Actions")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)

            HStack(spacing: 12) {
                QuickActionButton(
                    icon: "plus.circle.fill",
                    title: "New Workout",
                    color: CustomColor.primary
                ) {
                    withAnimation(.snappy) {
                        navigation.push(HomeScreen.addWorkout)
                    }
                }

                QuickActionButton(
                    icon: "chart.bar.fill",
                    title: "Progress",
                    color: CustomColor.primary.opacity(0.8)
                ) {
                    withAnimation(.snappy) {
                        navigation.push(HomeScreen.progress)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var emptyWorkoutState: some View {
        VStack(spacing: 12) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 40, weight: .semibold))
                .foregroundColor(.white.opacity(0.3))

            Text("No workouts yet")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)

            Text("Create your first workout to get started")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.04))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(CustomColor.primary.opacity(0.2), lineWidth: 1)
        )
    }

    @ViewBuilder
    private var emptyRecentState: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock")
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(.white.opacity(0.3))

            Text("No recent workouts")
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
    HomeView()
        .environment(NavigationCoordinator())
}
