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

    var body: some View {
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    todaysWorkoutSection
                    recentWorkoutsSection
                    quickActionsSection

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    @ViewBuilder
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
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
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Workout")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)

            WorkoutCard(
                title: viewModel.todaysWorkout.title,
                exercises: viewModel.todaysWorkout.exercises,
                time: viewModel.todaysWorkout.time,
                isCompleted: viewModel.todaysWorkout.isCompleted
            ) {
                navigation.push(HomeScreen.workoutDetail(viewModel.todaysWorkout))
            }
        }
    }
    
    @ViewBuilder
    private var recentWorkoutsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Workouts")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Button {
                    navigation.push(HomeScreen.allWorkouts)
                } label: {
                    Text("View All")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CustomColor.primary)
                }
            }

            VStack(spacing: 12) {
                ForEach(viewModel.recentWorkouts) { workout in
                    WorkoutCard(
                        title: workout.title,
                        exercises: workout.exercises,
                        time: workout.time,
                        isCompleted: workout.isCompleted,
                        date: workout.date
                    ) {
                        navigation.push(HomeScreen.workoutDetail(workout))
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)

            HStack(spacing: 12) {
                QuickActionButton(
                    icon: "plus.circle.fill",
                    title: "New Workout",
                    color: CustomColor.primary
                ) {
                    navigation.push(HomeScreen.addWorkout)
                }

                QuickActionButton(
                    icon: "chart.bar.fill",
                    title: "Progress",
                    color: CustomColor.primary.opacity(0.8)
                ) {
                    navigation.push(HomeScreen.progress)
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(NavigationCoordinator())
}
