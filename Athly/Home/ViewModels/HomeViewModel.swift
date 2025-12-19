//
//  HomeViewModel.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

@Observable
class HomeViewModel {
    var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }
    
    var todaysWorkout: WorkoutData {
        WorkoutData(
            title: "Push Day",
            exercises: "Bench Press, Shoulder Press, Triceps",
            time: "60 min",
            isCompleted: false
        )
    }

    var recentWorkouts: [WorkoutData] {
        [
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
            )
        ]
    }
}

