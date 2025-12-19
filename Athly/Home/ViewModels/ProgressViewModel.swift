//
//  ProgressViewModel.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

@Observable
class ProgressViewModel {
    var selectedTimeRange: TimeRange = .week
    
    var totalWorkouts: Int {
        24 // Mock data
    }
    
    var totalCalories: String {
        "12.5K" // Mock data
    }
    
    var totalTime: String {
        "28h" // Mock data
    }
    
    var currentStreak: Int {
        7 // Mock data
    }
    
    var chartData: [ChartData] {
        switch selectedTimeRange {
        case .week:
            return [
                ChartData(day: "Mon", workouts: 2),
                ChartData(day: "Tue", workouts: 1),
                ChartData(day: "Wed", workouts: 3),
                ChartData(day: "Thu", workouts: 1),
                ChartData(day: "Fri", workouts: 2),
                ChartData(day: "Sat", workouts: 4),
                ChartData(day: "Sun", workouts: 1)
            ]
        case .month:
            return [
                ChartData(day: "Week 1", workouts: 8),
                ChartData(day: "Week 2", workouts: 6),
                ChartData(day: "Week 3", workouts: 7),
                ChartData(day: "Week 4", workouts: 9)
            ]
        case .year:
            return [
                ChartData(day: "Jan", workouts: 20),
                ChartData(day: "Feb", workouts: 18),
                ChartData(day: "Mar", workouts: 24),
                ChartData(day: "Apr", workouts: 22),
                ChartData(day: "May", workouts: 26),
                ChartData(day: "Jun", workouts: 23)
            ]
        }
    }
    
    var categoryData: [(icon: String, title: String, workouts: Int, total: Int, color: Color)] {
        [
            (icon: "dumbbell.fill", title: "Strength", workouts: 15, total: 24, color: CustomColor.primary),
            (icon: "heart.fill", title: "Cardio", workouts: 6, total: 24, color: CustomColor.accent),
            (icon: "figure.flexibility", title: "Flexibility", workouts: 3, total: 24, color: CustomColor.link)
        ]
    }
    
    var achievements: [(icon: String, title: String, description: String, color: Color)] {
        [
            (icon: "flame.fill", title: "7 Day Streak", description: "Keep the momentum going!", color: CustomColor.success),
            (icon: "star.fill", title: "20 Workouts", description: "You've completed 20 workouts this month", color: CustomColor.accent),
            (icon: "bolt.fill", title: "Personal Best", description: "New record on Bench Press", color: CustomColor.primary)
        ]
    }
    
    func changeTimeRange(to range: TimeRange) {
        selectedTimeRange = range
    }
}
