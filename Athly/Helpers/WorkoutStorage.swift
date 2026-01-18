//
//  WorkoutStorage.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import Foundation

extension Notification.Name {
    static let workoutsDidChange = Notification.Name("workoutsDidChange")
}

@MainActor
class WorkoutStorage {
    static let shared = WorkoutStorage()

    private init() {}

    private func storageKey(for userId: String?) -> String {
        if let userId = userId {
            return "\(UserDefaultConstants.UserDefaultKey.userWorkouts.rawValue)_\(userId)"
        }
        return UserDefaultConstants.UserDefaultKey.userWorkouts.rawValue
    }
    
    func saveWorkouts(_ workouts: [WorkoutData], userId: String? = nil) {
        let key = storageKey(for: userId)
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(workouts)
            UserDefaults.standard.set(data, forKey: key)
            NotificationCenter.default.post(name: .workoutsDidChange, object: userId)
        } catch {
            print("Failed to save workouts: \(error.localizedDescription)")
        }
    }
    
    func loadWorkouts(userId: String? = nil) -> [WorkoutData] {
        let key = storageKey(for: userId)
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let workouts = try decoder.decode([WorkoutData].self, from: data)
            return workouts
        } catch {
            print("Failed to load workouts: \(error.localizedDescription)")
            return []
        }
    }
    
    func addWorkout(_ workout: WorkoutData, userId: String? = nil) {
        var workouts = loadWorkouts(userId: userId)
        workouts.insert(workout, at: 0)
        saveWorkouts(workouts, userId: userId)
    }
    
    func updateWorkout(_ workout: WorkoutData, userId: String? = nil) {
        var workouts = loadWorkouts(userId: userId)
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            var updatedWorkout = workout
            updatedWorkout = WorkoutData(
                id: workout.id,
                title: workout.title,
                exercises: workout.exercises,
                time: workout.time,
                isCompleted: workout.isCompleted,
                date: workout.date,
                customExercises: workout.customExercises,
                dateCreated: workouts[index].dateCreated,
                lastModified: Date()
            )
            workouts[index] = updatedWorkout
            saveWorkouts(workouts, userId: userId)
        }
    }
    
    func deleteWorkout(_ workoutId: UUID, userId: String? = nil) {
        var workouts = loadWorkouts(userId: userId)
        workouts.removeAll { $0.id == workoutId }
        saveWorkouts(workouts, userId: userId)
    }
}
