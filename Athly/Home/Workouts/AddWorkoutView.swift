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
                VStack(alignment: .leading, spacing: 24) {
                    header
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
        .sheet(isPresented: $viewModel.showAddExercise) {
            AddExerciseSheet { exercise in
                viewModel.addExercise(exercise)
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
                        .fill(Color.white.opacity(0.1))
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

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(WorkoutCategory.allCases, id: \.self) { category in
                        CategoryChip(
                            category: category,
                            isSelected: viewModel.selectedCategory == category
                        ) {
                            viewModel.selectedCategory = category
                        }
                    }
                }
            }
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
                        .fill(Color.white.opacity(0.05))
                )
            }
        }
    }

    @ViewBuilder
    private var exercisesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Exercises")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Button {
                    viewModel.showAddExercise = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add")
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(CustomColor.primary)
                }
            }

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
                                viewModel.deleteExercise(exercise)
                            }
                        )
                    }
                }
            }
        }
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

#Preview {
    NavigationStack {
        AddWorkoutView()
    }
    .environment(NavigationCoordinator())
    .environment(AddWorkoutViewModel())
    .environment(AllWorkoutsViewModel())
}
