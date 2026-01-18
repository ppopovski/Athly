//
//  ProgressViewModel.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

@MainActor
@Observable
class ProgressViewModel {
    var selectedTimeRange: TimeRange = .week
    var workouts: [WorkoutData] = []

    init() {
        loadWorkouts()
    }

    var totalWorkouts: Int {
        workouts.count
    }

    var totalTime: String {
        let totalMinutes = workouts.reduce(0) { total, workout in
            total + workout.timeMinutes
        }
        return formatMinutes(totalMinutes)
    }

    var currentStreak: Int {
        calculateStreak()
    }

    var chartData: [ChartData] {
        switch selectedTimeRange {
        case .week:
            return weeklyChartData()
        case .month:
            return monthlyChartData()
        case .year:
            return yearlyChartData()
        }
    }

    var categoryData: [CategoryStat] {
        []
    }

    func changeTimeRange(to range: TimeRange) {
        selectedTimeRange = range
    }

    func loadWorkouts() {
        let userId = AuthManager.shared.getUserId()
        workouts = WorkoutStorage.shared.loadWorkouts(userId: userId)
    }

    private func weeklyChartData() -> [ChartData] {
        let calendar = Calendar.current
        let today = Date()
        let last7Days = (0..<7).map { offset in
            calendar.date(byAdding: .day, value: -offset, to: today) ?? today
        }.reversed()

        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"

        return last7Days.map { date in
            let count = workouts.filter { calendar.isDate($0.dateCreated, inSameDayAs: date) }.count
            return ChartData(day: formatter.string(from: date), workouts: count)
        }
    }

    private func monthlyChartData() -> [ChartData] {
        let calendar = Calendar.current
        let today = Date()
        let weeks = (0..<4).map { offset in
            calendar.date(byAdding: .weekOfYear, value: -offset, to: today) ?? today
        }.reversed()

        return weeks.enumerated().map { index, weekStart in
            let weekRange = calendar.dateInterval(of: .weekOfYear, for: weekStart)
            let count = workouts.filter { workout in
                guard let range = weekRange else { return false }
                return range.contains(workout.dateCreated)
            }.count
            return ChartData(day: "Week \(index + 1)", workouts: count)
        }
    }

    private func yearlyChartData() -> [ChartData] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"

        let months = (0..<12).map { offset in
            calendar.date(byAdding: .month, value: -offset, to: Date()) ?? Date()
        }.reversed()

        return months.map { date in
            let monthRange = calendar.dateInterval(of: .month, for: date)
            let count = workouts.filter { workout in
                guard let range = monthRange else { return false }
                return range.contains(workout.dateCreated)
            }.count
            return ChartData(day: formatter.string(from: date), workouts: count)
        }
    }

    private func calculateStreak() -> Int {
        let calendar = Calendar.current
        var streak = 0
        var currentDate = Date()

        while workouts.contains(where: { calendar.isDate($0.dateCreated, inSameDayAs: currentDate) }) {
            streak += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        }

        return streak
    }

    private func formatMinutes(_ minutes: Int) -> String {
        guard minutes > 0 else { return "0h" }
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        if remainingMinutes == 0 {
            return "\(hours)h"
        }
        return "\(hours)h \(remainingMinutes)m"
    }
}
