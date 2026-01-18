//
//  AddWorkoutViewModel.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

@MainActor
@Observable
class AddWorkoutViewModel {
    var workoutTitle = ""
    var selectedCategory = WorkoutCategory.strength {
        didSet {
            // Reset weight/distance when category changes
            if selectedCategory != .strength {
                draftWeights = Array(repeating: 0, count: draftSets)
            }
            if selectedCategory != .cardio {
                draftDistance = ""
            }
        }
    }
    var estimatedTime = 60
    var exercises: [NewExercise] = []
    var draftExerciseName = ""
    var draftSets = 3 {
        didSet {
            // Update weights and reps arrays when sets change
            while draftWeights.count < draftSets {
                draftWeights.append(0)
            }
            while draftWeights.count > draftSets {
                draftWeights.removeLast()
            }
            while draftReps.count < draftSets {
                draftReps.append(10)
            }
            while draftReps.count > draftSets {
                draftReps.removeLast()
            }
        }
    }
    var draftReps: [Int] = [10, 10, 10] // Default to 3 sets worth
    var draftWeights: [Double] = [0, 0, 0] // Default to 3 sets worth
    var draftDistance: String = ""

    private var weightUnit: WeightUnit {
        loadWeightUnit()
    }

    private var distanceUnit: DistanceUnit {
        loadDistanceUnit()
    }

    var canSave: Bool {
        !workoutTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !exercises.isEmpty
    }

    var canAddExercise: Bool {
        !draftExerciseName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var weightUnitString: String {
        weightUnit == .kilograms ? "kg" : "lbs"
    }

    var distanceUnitString: String {
        distanceUnit == .kilometers ? "km" : "mi"
    }

    var shouldShowWeight: Bool {
        selectedCategory == .strength
    }

    var shouldShowDistance: Bool {
        selectedCategory == .cardio
    }

    private func loadWeightUnit() -> WeightUnit {
        if let weightUnitString = UserDefaults.standard.string(forKey: "weightUnit"),
           let weightUnit = WeightUnit(rawValue: weightUnitString) {
            return weightUnit
        }
        return .kilograms
    }

    private func loadDistanceUnit() -> DistanceUnit {
        if let distanceUnitString = UserDefaults.standard.string(forKey: "distanceUnit"),
           let distanceUnit = DistanceUnit(rawValue: distanceUnitString) {
            return distanceUnit
        }
        return .kilometers
    }

    func addExercise(_ exercise: NewExercise) {
        exercises.append(exercise)
    }

    func addDraftExercise() {
        let trimmedName = draftExerciseName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        var weights: [Double] = []
        if shouldShowWeight {
            weights = draftWeights.prefix(draftSets).map { $0 }
        }

        let reps = draftReps.prefix(draftSets).map { $0 }

        var distance: Double? = nil
        if shouldShowDistance, let distanceValue = Double(draftDistance), distanceValue > 0 {
            distance = distanceValue
        }

        let newExercise = NewExercise(
            name: trimmedName,
            sets: draftSets,
            reps: reps,
            weights: weights,
            distance: distance
        )

        exercises.append(newExercise)
        draftExerciseName = ""
        draftSets = 3
        draftReps = [10, 10, 10]
        draftWeights = [0, 0, 0]
        draftDistance = ""
    }

    func updateDraftWeight(at index: Int, value: String) {
        if index < draftWeights.count {
            draftWeights[index] = Double(value) ?? 0
        }
    }

    func updateDraftRep(at index: Int, value: String) {
        if index < draftReps.count {
            draftReps[index] = Int(value) ?? 10
        }
    }

    func deleteExercise(_ exercise: NewExercise) {
        exercises.removeAll { $0.id == exercise.id }
    }

    func saveWorkout(navigation: NavigationCoordinator, allWorkoutsViewModel: AllWorkoutsViewModel) {
        let trimmedTitle = workoutTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let exerciseList = exercises.map { exercise in
            var weightString = "—"
            if !exercise.weights.isEmpty && exercise.weights.contains(where: { $0 > 0 }) {
                // Format weights as "10kg, 12kg, 15kg" or "10kg / 12kg / 15kg"
                let weightValues = exercise.weights
                    .filter { $0 > 0 }
                    .map { String(format: "%.1f %@", $0, weightUnitString) }
                if !weightValues.isEmpty {
                    weightString = weightValues.joined(separator: " / ")
                }
            } else if let distance = exercise.distance, distance > 0 {
                weightString = String(format: "%.2f %@", distance, distanceUnitString)
            }

            // Format reps as "4, 10, 8" or "10" if all same
            let repsString: String
            if exercise.reps.count > 1 && Set(exercise.reps).count == 1 {
                // All reps are the same
                repsString = "\(exercise.reps[0])"
            } else {
                repsString = exercise.reps.map { "\($0)" }.joined(separator: ", ")
            }

            return ExerciseData(
                name: exercise.name,
                sets: exercise.sets,
                reps: repsString,
                weight: weightString
            )
        }
        let newWorkout = WorkoutData(
            title: trimmedTitle,
            exercises: exercises.map { $0.name }.joined(separator: ", "),
            time: "\(estimatedTime) min",
            isCompleted: false,
            customExercises: exerciseList
        )

        // Persist the workout using the view model's public method
        allWorkoutsViewModel.addWorkout(newWorkout)

        // Reset the form and navigate back
        reset()
        navigation.pop()
    }

    func reset() {
        workoutTitle = ""
        selectedCategory = .strength
        estimatedTime = 60
        exercises = []
        draftExerciseName = ""
        draftSets = 3
        draftReps = [10, 10, 10]
        draftWeights = [0, 0, 0]
        draftDistance = ""
    }
}
