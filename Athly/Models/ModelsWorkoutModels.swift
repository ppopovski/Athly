//
//  WorkoutModels.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import Foundation

struct WorkoutData: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let exercises: String
    let time: String
    var isCompleted: Bool = false
    var date: String? = nil
    
    var exerciseList: [ExerciseData] {
        switch title {
        case "Push Day":
            return [
                ExerciseData(name: "Bench Press", sets: 4, reps: "8-10", weight: "185 lbs"),
                ExerciseData(name: "Shoulder Press", sets: 3, reps: "10-12", weight: "95 lbs"),
                ExerciseData(name: "Triceps Dips", sets: 3, reps: "12-15", weight: "Body weight")
            ]
        case "Pull Day":
            return [
                ExerciseData(name: "Deadlifts", sets: 4, reps: "6-8", weight: "275 lbs"),
                ExerciseData(name: "Pull-ups", sets: 3, reps: "8-10", weight: "Body weight"),
                ExerciseData(name: "Barbell Rows", sets: 3, reps: "10-12", weight: "155 lbs")
            ]
        case "Leg Day":
            return [
                ExerciseData(name: "Squats", sets: 4, reps: "8-10", weight: "225 lbs"),
                ExerciseData(name: "Lunges", sets: 3, reps: "12-15", weight: "45 lbs"),
                ExerciseData(name: "Leg Press", sets: 3, reps: "12-15", weight: "315 lbs")
            ]
        default:
            return [
                ExerciseData(name: "Running", sets: 1, reps: "30 min", weight: "—"),
                ExerciseData(name: "Planks", sets: 3, reps: "60 sec", weight: "Body weight"),
                ExerciseData(name: "Crunches", sets: 3, reps: "20", weight: "Body weight")
            ]
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: WorkoutData, rhs: WorkoutData) -> Bool {
        lhs.id == rhs.id
    }
}

struct ExerciseData: Identifiable {
    let id = UUID()
    let name: String
    let sets: Int
    let reps: String
    let weight: String
}

struct NewExercise: Identifiable {
    let id = UUID()
    let name: String
    let sets: Int
    let reps: Int
}

enum WorkoutCategory: String, CaseIterable {
    case strength = "Strength"
    case cardio = "Cardio"
    case flexibility = "Flexibility"
    case sports = "Sports"
    case hiit = "HIIT"

    var icon: String {
        switch self {
        case .strength: return "dumbbell.fill"
        case .cardio: return "heart.fill"
        case .flexibility: return "figure.flexibility"
        case .sports: return "sportscourt.fill"
        case .hiit: return "flame.fill"
        }
    }
}

enum WorkoutFilter: String, CaseIterable {
    case all = "All"
    case completed = "Completed"
    case upcoming = "Upcoming"
}

enum TimeRange: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

struct ChartData {
    let day: String
    let workouts: Int
}
