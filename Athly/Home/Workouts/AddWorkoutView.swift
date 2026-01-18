//
//  AddWorkoutView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct AddWorkoutView: View {
    @Environment(NavigationCoordinator.self) private var navigation
    @Environment(\.dismiss) private var dismiss
    @Environment(AddWorkoutViewModel.self) private var viewModel
    @Environment(AllWorkoutsViewModel.self) private var allWorkoutsViewModel

    var body: some View {
        @Bindable var viewModel = viewModel
        
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    header
                    pipelineSection
                    basicInfoSection
                    categorySection
                    timeSection
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
            Text("Create Your Workout")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(CustomColor.primary)

            Text("Design a workout that fits your goals")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.top, 10)
    }

    @ViewBuilder
    private var pipelineSection: some View {
        @Bindable var viewModel = viewModel

        VStack(alignment: .leading, spacing: 12) {
            Text("Build Pipeline")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)

            VStack(spacing: 10) {
                PipelineRow(
                    title: "Name & Details",
                    isComplete: !viewModel.workoutTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                )
                PipelineRow(
                    title: "Add Exercises",
                    isComplete: !viewModel.exercises.isEmpty
                )
                PipelineRow(
                    title: "Save Workout",
                    isComplete: viewModel.canSave
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.04))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(CustomColor.primary.opacity(0.4), lineWidth: 1)
        )
        .animation(.snappy, value: viewModel.workoutTitle)
        .animation(.snappy, value: viewModel.exercises.count)
    }

    @ViewBuilder
    private var basicInfoSection: some View {
        @Bindable var viewModel = viewModel
        
        VStack(alignment: .leading, spacing: 12) {
            Text("Workout Name")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)

            TextField("e.g., Push Day, Leg Day", text: $viewModel.workoutTitle)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: TextFieldCornerRadius)
                        .fill(Color.white.opacity(0.06))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: TextFieldCornerRadius)
                        .stroke(CustomColor.primary.opacity(0.4), lineWidth: 1)
                )
                .autocorrectionDisabled()
        }
    }

    @ViewBuilder
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Category")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(WorkoutCategory.allCases, id: \.self) { category in
                        CategoryChip(
                            category: category,
                            isSelected: viewModel.selectedCategory == category
                        ) {
                            withAnimation(.snappy) {
                            viewModel.selectedCategory = category
                            }
                        }
                    }
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
            }
            .padding(.horizontal, -16)
        }
    }

    @ViewBuilder
    private var timeSection: some View {
        @Bindable var viewModel = viewModel
        
        VStack(alignment: .leading, spacing: 12) {
            Text("Estimated Duration")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)

            HStack(spacing: 16) {
                Stepper(value: $viewModel.estimatedTime, in: 15...180, step: 15) {
                    HStack {
                        Text("\(viewModel.estimatedTime)")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(CustomColor.primary)

                        Text("minutes")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.04))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(CustomColor.primary.opacity(0.4), lineWidth: 1)
                )
                .tint(CustomColor.primary)
            }
        }
    }

    @ViewBuilder
    private var exercisesSection: some View {
        @Bindable var viewModel = viewModel

        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Exercises")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Spacer()
                Text("\(viewModel.exercises.count)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
            }

            exerciseInputCard

            if viewModel.exercises.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "dumbbell")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(.white.opacity(0.3))

                    Text("No exercises added yet")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.6))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.03))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                .foregroundColor(.white.opacity(0.2))
                        )
                )
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(viewModel.exercises.enumerated()), id: \.element.id) { index, exercise in
                        NewExerciseRow(
                            exercise: exercise,
                            index: index + 1,
                            onDelete: {
                                withAnimation(.snappy) {
                                viewModel.deleteExercise(exercise)
                                }
                            }
                        )
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                    }
                }
                .animation(.snappy, value: viewModel.exercises.count)
            }
        }
    }

    @ViewBuilder
    private var exerciseInputCard: some View {
        @Bindable var viewModel = viewModel

        VStack(alignment: .leading, spacing: 12) {
            Text("Add an exercise")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))

            TextField("e.g., Bench Press", text: $viewModel.draftExerciseName)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: TextFieldCornerRadius)
                        .fill(Color.white.opacity(0.06))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: TextFieldCornerRadius)
                        .stroke(CustomColor.primary.opacity(0.4), lineWidth: 1)
                )
                .autocorrectionDisabled()
                .submitLabel(.done)
                .onSubmit {
                    guard viewModel.canAddExercise else { return }
                    withAnimation(.snappy) {
                        viewModel.addDraftExercise()
                    }
                }

            Stepper(value: $viewModel.draftSets, in: 1...10) {
                Text("\(viewModel.draftSets) sets")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.04))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(CustomColor.primary.opacity(0.4), lineWidth: 1)
            )
            .tint(CustomColor.primary)

            if viewModel.shouldShowWeight {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Weight & Reps per Set")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))

                    ForEach(0..<viewModel.draftSets, id: \.self) { index in
                        HStack(spacing: 8) {
                            Text("Set \(index + 1)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 50, alignment: .leading)

                            // Weight input
                            TextField("0", text: Binding(
                                get: {
                                    if index < viewModel.draftWeights.count {
                                        let value = viewModel.draftWeights[index]
                                        return value > 0 ? String(format: "%.1f", value) : ""
                                    }
                                    return ""
                                },
                                set: { newValue in
                                    viewModel.updateDraftWeight(at: index, value: newValue)
                                }
                            ))
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .keyboardType(.decimalPad)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: TextFieldCornerRadius)
                                    .fill(Color.white.opacity(0.06))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: TextFieldCornerRadius)
                                    .stroke(CustomColor.primary.opacity(0.4), lineWidth: 1)
                            )

                            Text(viewModel.weightUnitString)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 35, alignment: .leading)

                            // Reps input
                            TextField("10", text: Binding(
                                get: {
                                    if index < viewModel.draftReps.count {
                                        let value = viewModel.draftReps[index]
                                        return value > 0 ? "\(value)" : ""
                                    }
                                    return ""
                                },
                                set: { newValue in
                                    viewModel.updateDraftRep(at: index, value: newValue)
                                }
                            ))
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .keyboardType(.numberPad)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: TextFieldCornerRadius)
                                    .fill(Color.white.opacity(0.06))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: TextFieldCornerRadius)
                                    .stroke(CustomColor.primary.opacity(0.4), lineWidth: 1)
                            )
                            .frame(width: 70)

                            Text("reps")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 40, alignment: .leading)
                        }
                    }
                }
            }

            if viewModel.shouldShowDistance {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Distance (\(viewModel.distanceUnitString))")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))

                    HStack(spacing: 8) {
                        TextField("0", text: $viewModel.draftDistance)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .keyboardType(.decimalPad)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: TextFieldCornerRadius)
                                    .fill(Color.white.opacity(0.06))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: TextFieldCornerRadius)
                                    .stroke(CustomColor.primary.opacity(0.4), lineWidth: 1)
                            )

                        Text(viewModel.distanceUnitString)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }

            CustomButton(
                buttonText: "Add Exercise",
                cornerRadius: 12,
                disabled: !viewModel.canAddExercise,
                backgroundColor: viewModel.canAddExercise ? CustomColor.primary : CustomColor.disabledButtonGrey,
                contentsColor: CustomColor.bgBlack,
                buttonType: .smallPrimary,
                action: {
                    withAnimation(.snappy) {
                        viewModel.addDraftExercise()
                    }
                }
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.03))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(CustomColor.primary.opacity(0.25), lineWidth: 1)
        )
    }

    @ViewBuilder
    private var actionButtons: some View {
        VStack(spacing: 12) {
            CustomButton(
                buttonText: "Save Workout",
                cornerRadius: ButtonCornerRadius,
                disabled: !viewModel.canSave,
                backgroundColor: viewModel.canSave ? CustomColor.primary : CustomColor.disabledButtonGrey,
                contentsColor: CustomColor.bgBlack,
                buttonType: .primary,
                action: {
                    viewModel.saveWorkout(navigation: navigation, allWorkoutsViewModel: allWorkoutsViewModel)
                }
            )

            CustomButton(
                buttonText: "Cancel",
                cornerRadius: ButtonCornerRadius,
                backgroundColor: CustomColor.bgBlack,
                contentsColor: CustomColor.primary,
                buttonType: .secondary,
                action: {
                    navigation.pop()
                }
            )
        }
    }
}

private struct PipelineRow: View {
    let title: String
    let isComplete: Bool

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(isComplete ? CustomColor.primary : Color.clear)
                    .frame(width: 22, height: 22)
                    .overlay(
                        Circle()
                            .stroke(CustomColor.primary.opacity(0.6), lineWidth: 1)
                    )

                if isComplete {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(CustomColor.bgBlack)
                }
            }

            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))

            Spacer()
        }
        .animation(.snappy, value: isComplete)
    }
}

#Preview {
    NavigationStack {
        AddWorkoutView()
    }
    .environment(NavigationCoordinator())
    .environment(AddWorkoutViewModel())
    .environment(AllWorkoutsViewModel())
}
