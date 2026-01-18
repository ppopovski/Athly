//
//  CalendarViewModel.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

@MainActor
@Observable
class CalendarViewModel {
    var selectedDate = Date()
    var currentMonth = Date()
    var workouts: [WorkoutData] = []

    init() {
        loadWorkouts()
    }

    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }

    var selectedDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: selectedDate)
    }

    var selectedDateWorkouts: [WorkoutData] {
        workouts.filter { Calendar.current.isDate($0.dateCreated, inSameDayAs: selectedDate) }
    }

    func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }

    func selectDate(_ date: Date) {
        selectedDate = date
    }

    func getDaysInMonth() -> [Date?] {
        var days: [Date?] = []
        let calendar = Calendar.current

        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return days
        }

        let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        guard let lastWeekEnd = monthLastWeek?.end else { return days }

        var currentDate = monthFirstWeek.start

        while currentDate < lastWeekEnd {
            if calendar.isDate(currentDate, equalTo: currentMonth, toGranularity: .month) {
                days.append(currentDate)
            } else {
                days.append(nil)
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }

        return days
    }

    func hasWorkout(on date: Date) -> Bool {
        workouts.contains { Calendar.current.isDate($0.dateCreated, inSameDayAs: date) }
    }

    func isSelected(_ date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }

    func loadWorkouts() {
        let userId = AuthManager.shared.getUserId()
        workouts = WorkoutStorage.shared.loadWorkouts(userId: userId)
    }
}
