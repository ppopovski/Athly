//
//  WorkoutComponents.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct CategoryChip: View {
    let category: WorkoutCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 14, weight: .semibold))

                Text(category.rawValue)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(isSelected ? CustomColor.bgBlack : .white.opacity(0.7))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? CustomColor.primary : Color.white.opacity(0.1))
            )
        }
    }
}

struct NewExerciseRow: View {
    let exercise: NewExercise
    let index: Int
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text("\(index)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(CustomColor.primary)
                .frame(width: 28, height: 28)
                .background(
                    Circle()
                        .fill(CustomColor.primary.opacity(0.2))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Text("\(exercise.sets) sets × \(exercise.reps) reps")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(CustomColor.error)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
}

struct AddExerciseSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onAdd: (NewExercise) -> Void
    
    @State private var exerciseName = ""
    @State private var sets = 3
    @State private var reps = 10

    var body: some View {
        NavigationStack {
            ZStack {
                CustomColor.bgBlack.ignoresSafeArea()

                VStack(spacing: 24) {
                    HStack {
                        Text("Add Excersise")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(CustomColor.primary)
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Exercise Name")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)

                        TextField("e.g., Bench Press", text: $exerciseName)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: TextFieldCornerRadius)
                                    .fill(Color.white.opacity(0.1))
                            )
                            .autocorrectionDisabled()
                    }

                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Sets")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)

                            Stepper(value: $sets, in: 1...10) {
                                Text("\(sets)")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(CustomColor.primary)
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.05))
                            )
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Reps")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)

                            Stepper(value: $reps, in: 1...50) {
                                Text("\(reps)")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(CustomColor.primary)
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.05))
                            )
                        }
                    }

                    CustomButton(
                        buttonText: "Add Exercise",
                        cornerRadius: ButtonCornerRadius,
                        disabled: exerciseName.isEmpty,
                        backgroundColor: !exerciseName.isEmpty ? CustomColor.primary : CustomColor.disabledButtonGrey,
                        contentsColor: CustomColor.bgBlack,
                        buttonType: .primary,
                        action: {
                            onAdd(NewExercise(
                                name: exerciseName,
                                sets: sets,
                                reps: reps
                            ))
                            dismiss()
                        }
                    )
                    
                    Spacer()
                }
                .padding(20)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(CustomColor.primary)
                }
            }
        }
    }
}

// MARK: - Filter Tab

struct FilterTab: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? CustomColor.bgBlack : .white.opacity(0.7))
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? CustomColor.primary : Color.white.opacity(0.1))
                )
        }
    }
}

// MARK: - Exercise Row (for detail view)

struct ExerciseRow: View {
    let exercise: ExerciseData

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(CustomColor.primary.opacity(0.2))
                    .frame(width: 50, height: 50)

                Image(systemName: "dumbbell")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(CustomColor.primary)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(exercise.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)

                HStack(spacing: 12) {
                    Label {
                        Text("\(exercise.sets) sets")
                            .font(.system(size: 13, weight: .medium))
                    } icon: {
                        Image(systemName: "repeat")
                            .font(.system(size: 11))
                    }
                    .foregroundColor(.white.opacity(0.7))

                    Label {
                        Text("\(exercise.reps) reps")
                            .font(.system(size: 13, weight: .medium))
                    } icon: {
                        Image(systemName: "number")
                            .font(.system(size: 11))
                    }
                    .foregroundColor(.white.opacity(0.7))
                }
            }

            Spacer()

            Text(exercise.weight)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(CustomColor.primary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.03))
        )
    }
}

// MARK: - Stat Card (for detail view)

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(color)

            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)

            Text(title)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}
