//
//  AllWorkoutsViewModel.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

@Observable
class AllWorkoutsViewModel {
    var searchText = ""
    var selectedFilter: WorkoutFilter = .all
    
    // Mock data - replace with actual data from database/API
    var allWorkouts: [WorkoutData] = [
        WorkoutData(
            title: "Push Day",
            exercises: "Bench Press, Shoulder Press, Triceps",
            time: "60 min",
            isCompleted: false
        ),
        WorkoutData(
            title: "Pull Day",
            exercises: "Deadlifts, Pull-ups, Rows",
            time: "55 min",
            isCompleted: true,
            date: "Yesterday"
        ),
        WorkoutData(
            title: "Leg Day",
            exercises: "Squats, Lunges, Leg Press",
            time: "70 min",
            isCompleted: true,
            date: "2 days ago"
        ),
        WorkoutData(
            title: "Cardio & Abs",
            exercises: "Running, Planks, Crunches",
            time: "45 min",
            isCompleted: true,
            date: "3 days ago"
        ),
        WorkoutData(
            title: "Upper Body",
            exercises: "Pull-ups, Dips, Rows",
            time: "50 min",
            isCompleted: true,
            date: "4 days ago"
        ),
        WorkoutData(
            title: "Full Body",
            exercises: "Squats, Bench, Deadlifts",
            time: "80 min",
            isCompleted: true,
            date: "5 days ago"
        )
    ]
    
    var filteredWorkouts: [WorkoutData] {
        let filtered = allWorkouts.filter { workout in
            switch selectedFilter {
            case .all:
                return true
            case .completed:
                return workout.isCompleted
            case .upcoming:
                return !workout.isCompleted
            }
        }
        
        if searchText.isEmpty {
            return filtered
        }
        
        return filtered.filter { workout in
            workout.title.localizedCaseInsensitiveContains(searchText) ||
            workout.exercises.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func changeFilter(to filter: WorkoutFilter) {
        selectedFilter = filter
    }
    
    func clearSearch() {
        searchText = ""
    }
    
    func addWorkout(_ workout: WorkoutData) {
        allWorkouts.insert(workout, at: 0)
    }
}
