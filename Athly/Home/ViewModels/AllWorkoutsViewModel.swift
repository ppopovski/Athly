//
//  AllWorkoutsViewModel.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

@MainActor
@Observable
class AllWorkoutsViewModel {
    var searchText = ""
    var selectedFilter: WorkoutFilter = .all
    var allWorkouts: [WorkoutData] = []
    
    init() {
        loadWorkouts()
    }
    
    private func getUserId() -> String? {
        return AuthManager.shared.getUserId()
    }
    
    func loadWorkouts() {
        allWorkouts = WorkoutStorage.shared.loadWorkouts(userId: getUserId())
    }
    
    var todaysWorkout: WorkoutData? {
        let today = Date()
        let calendar = Calendar.current
        return allWorkouts.first { workout in
            calendar.isDate(workout.dateCreated, inSameDayAs: today) && !workout.isCompleted
        }
    }
    
    var recentWorkouts: [WorkoutData] {
        let today = Date()
        let calendar = Calendar.current
        let workoutsExcludingToday = allWorkouts.filter { workout in
            !calendar.isDate(workout.dateCreated, inSameDayAs: today)
        }
        return Array(workoutsExcludingToday.prefix(3))
    }
    
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
        WorkoutStorage.shared.addWorkout(workout, userId: getUserId())
    }

    func updateWorkout(_ workout: WorkoutData) {
        if let index = allWorkouts.firstIndex(where: { $0.id == workout.id }) {
            allWorkouts[index] = workout
            WorkoutStorage.shared.updateWorkout(workout, userId: getUserId())
        }
    }

    func deleteWorkout(_ workout: WorkoutData) {
        allWorkouts.removeAll { $0.id == workout.id }
        WorkoutStorage.shared.deleteWorkout(workout.id, userId: getUserId())
    }

    func refreshWorkouts() {
        loadWorkouts()
    }
}
