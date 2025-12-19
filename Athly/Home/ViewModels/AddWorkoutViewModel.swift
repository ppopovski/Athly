//
//  AddWorkoutViewModel.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

@Observable
class AddWorkoutViewModel {
    var workoutTitle = ""
    var selectedCategory = WorkoutCategory.strength
    var estimatedTime = 60
    var exercises: [NewExercise] = []
    var showAddExercise = false
    
    var canSave: Bool {
        !workoutTitle.isEmpty && !exercises.isEmpty
    }
    
    func addExercise(_ exercise: NewExercise) {
        exercises.append(exercise)
    }
    
    func deleteExercise(_ exercise: NewExercise) {
        exercises.removeAll { $0.id == exercise.id }
    }
    
    func saveWorkout(navigation: NavigationCoordinator, allWorkoutsViewModel: AllWorkoutsViewModel) {
        let newWorkout = WorkoutData(
            title: workoutTitle,
            exercises: exercises.map { $0.name }.joined(separator: ", "),
            time: "\(estimatedTime) min",
            isCompleted: false
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
        showAddExercise = false
    }
}
