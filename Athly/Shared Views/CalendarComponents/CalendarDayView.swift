//
//  CalendarDayView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct CalendarDayView: View {
    let date: Date
    var isSelected: Bool = false
    var hasWorkout: Bool = false

    var body: some View {
        ZStack {
            if isSelected {
                RoundedRectangle(cornerRadius: 12)
                    .fill(CustomColor.primary)
            } else if hasWorkout {
                RoundedRectangle(cornerRadius: 12)
                    .fill(CustomColor.primary.opacity(0.2))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
            }

            VStack(spacing: 4) {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isSelected ? CustomColor.bgBlack : .white)

                if hasWorkout && !isSelected {
                    Circle()
                        .fill(CustomColor.primary)
                        .frame(width: 4, height: 4)
                }
            }
        }
        .frame(height: 50)
    }
}

#Preview {
    ZStack {
        CustomColor.bgBlack.ignoresSafeArea()

        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
            CalendarDayView(date: Date(), isSelected: false, hasWorkout: false)
            CalendarDayView(date: Date(), isSelected: true, hasWorkout: false)
            CalendarDayView(date: Date(), isSelected: false, hasWorkout: true)
        }
        .padding()
    }
}
