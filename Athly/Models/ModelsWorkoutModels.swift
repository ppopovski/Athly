//
//  WorkoutModels.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import Foundation

struct WorkoutData: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let exercises: String
    let time: String
    var isCompleted: Bool = false
    var date: String?
    var customExercises: [ExerciseData]?
    let dateCreated: Date
    var lastModified: Date

    init(
        id: UUID = UUID(),
        title: String,
        exercises: String,
        time: String,
        isCompleted: Bool = false,
        date: String? = nil,
        customExercises: [ExerciseData]? = nil,
        dateCreated: Date = Date(),
        lastModified: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.exercises = exercises
        self.time = time
        self.isCompleted = isCompleted
        self.date = date
        self.customExercises = customExercises
        self.dateCreated = dateCreated
        self.lastModified = lastModified
    }

    var exerciseList: [ExerciseData] {
        if let customExercises, !customExercises.isEmpty {
            return customExercises
        }
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

extension WorkoutData {
    var timeMinutes: Int {
        let components = time.lowercased().components(separatedBy: " ")
        guard let value = Int(components.first ?? "") else { return 0 }
        if time.lowercased().contains("hour") || time.lowercased().contains("hr") {
            return value * 60
        }
        return value
    }
}

struct ExerciseData: Identifiable, Codable {
    let id: UUID
    let name: String
    let sets: Int
    let reps: String
    let weight: String

    init(id: UUID = UUID(), name: String, sets: Int, reps: String, weight: String) {
        self.id = id
        self.name = name
        self.sets = sets
        self.reps = reps
        self.weight = weight
    }
}

struct NewExercise: Identifiable {
    let id = UUID()
    let name: String
    let sets: Int
    var reps: [Int] // One rep count per set
    var weights: [Double] // One weight per set
    var distance: Double?
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

struct ChartData: Codable {
    let day: String
    let workouts: Int
}
