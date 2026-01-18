//
//  WorkoutDetailView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct WorkoutDetailView: View {
    @Environment(NavigationCoordinator.self) private var navigation
    @Environment(\.dismiss) private var dismiss
    let workout: WorkoutData
    @State private var showCompleteAnimation = false

    var body: some View {
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    statsSection
                    exercisesSection
                    actionButtons

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private var headerSection: some View {
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
            HStack {
                ZStack {
                    Circle()
                        .fill(workout.isCompleted ? CustomColor.primary.opacity(0.2) : CustomColor.primary)
                        .frame(width: 70, height: 70)

                    Image(systemName: workout.isCompleted ? "checkmark" : "figure.strengthtraining.traditional")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(workout.isCompleted ? CustomColor.primary : CustomColor.bgBlack)
                }

                Spacer()

                if workout.isCompleted {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Completed")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(CustomColor.success)

                        if let date = workout.date {
                            Text(date)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                }
            }

            Text(workout.title)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)

            Text(workout.exercises)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.top, 20)
    }

    @ViewBuilder
    private var statsSection: some View {
        HStack(spacing: 16) {
            StatCard(
                icon: "clock.fill",
                title: "Duration",
                value: workout.time,
                color: CustomColor.primary
            )

            StatCard(
                icon: "flame.fill",
                title: "Exercises",
                value: "\(workout.exerciseList.count)",
                color: CustomColor.accent
            )

            StatCard(
                icon: "dumbbell.fill",
                title: "Total Sets",
                value: "\(workout.exerciseList.reduce(0) { $0 + $1.sets })",
                color: CustomColor.link
            )
        }
    }

    @ViewBuilder
    private var exercisesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Exercises")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)

            VStack(spacing: 12) {
                ForEach(workout.exerciseList) { exercise in
                    ExerciseRow(exercise: exercise)
                }
            }
        }
    }

    @ViewBuilder
    private var actionButtons: some View {
        VStack(spacing: 12) {
            if !workout.isCompleted {
                CustomButton(
                    buttonText: "Edit Workout",
                    cornerRadius: ButtonCornerRadius,
                    backgroundColor: CustomColor.bgBlack,
                    contentsColor: CustomColor.primary,
                    buttonType: .secondary,
                    action: {
                        // Edit workout action
                    }
                )
            } else {
                CustomButton(
                    buttonText: "Do Again",
                    cornerRadius: ButtonCornerRadius,
                    backgroundColor: CustomColor.bgBlack,
                    contentsColor: CustomColor.primary,
                    buttonType: .secondary,
                    action: {
                        // Repeat workout action
                    }
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        WorkoutDetailView(
            workout: WorkoutData(
                title: "Push Day",
                exercises: "Bench Press, Shoulder Press, Triceps",
                time: "60 min",
                isCompleted: true
            )
        )
    }
    .environment(NavigationCoordinator())
}
