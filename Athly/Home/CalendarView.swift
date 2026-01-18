//
//  CalendarView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct CalendarView: View {
    @Environment(CalendarViewModel.self) private var viewModel

    var body: some View {
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    monthNavigation
                    calendarGrid
                    selectedDateWorkouts

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
            }
        }
        .onAppear {
            viewModel.loadWorkouts()
        }
    }
    
    @ViewBuilder
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Workout Calendar")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(CustomColor.primary)

            Text("Track your training schedule")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    private var monthNavigation: some View {
        HStack {
            Button {
                viewModel.changeMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(CustomColor.primary)
            }

            Spacer()

            Text(viewModel.monthYearString)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            Spacer()

            Button {
                viewModel.changeMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(CustomColor.primary)
            }
        }
        .padding(.horizontal, 8)
    }
    
    @ViewBuilder
    private var calendarGrid: some View {
        VStack(spacing: 12) {
            weekdayHeaders
            daysGrid
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
        )
    }

    @ViewBuilder
    private var weekdayHeaders: some View {
        HStack(spacing: 0) {
            ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                Text(day)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(maxWidth: .infinity)
            }
        }
    }

    @ViewBuilder
    private var daysGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
            ForEach(viewModel.getDaysInMonth(), id: \.self) { date in
                if let date = date {
                    CalendarDayView(
                        date: date,
                        isSelected: viewModel.isSelected(date),
                        hasWorkout: viewModel.hasWorkout(on: date)
                    )
                    .onTapGesture {
                        viewModel.selectDate(date)
                    }
                } else {
                    Color.clear.frame(height: 50)
                }
            }
        }
    }
    
    @ViewBuilder
    private var selectedDateWorkouts: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Workouts on \(viewModel.selectedDateString)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            if viewModel.selectedDateWorkouts.isEmpty {
                Text("No workouts scheduled")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.selectedDateWorkouts) { workout in
                        WorkoutCard(
                            title: workout.title,
                            exercises: workout.exercises,
                            time: workout.time,
                            isCompleted: workout.isCompleted
                        ) {
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CalendarView()
}
