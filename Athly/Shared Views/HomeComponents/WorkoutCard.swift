//
//  WorkoutCard.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct WorkoutCard: View {
    let title: String
    let exercises: String
    let time: String
    var isCompleted: Bool = false
    var date: String?
    var onTap: (() -> Void)? = nil

    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(isCompleted ? CustomColor.primary.opacity(0.2) : CustomColor.primary)
                        .frame(width: 50, height: 50)

                    Image(systemName: isCompleted ? "checkmark" : "figure.strengthtraining.traditional")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(isCompleted ? CustomColor.primary : CustomColor.bgBlack)
                }

                // Info
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)

                        if let date = date {
                            Spacer()
                            Text(date)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }

                    Text(exercises)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)

                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                        Text(time)
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(CustomColor.primary)
                }

                Spacer()
                
                // Chevron indicator
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(CustomColor.primary.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(WorkoutCardButtonStyle())
    }
}

// Custom button style for subtle press effect
struct WorkoutCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    ZStack {
        CustomColor.bgBlack.ignoresSafeArea()

        VStack(spacing: 12) {
            WorkoutCard(
                title: "Push Day",
                exercises: "Bench Press, Shoulder Press, Triceps",
                time: "60 min",
                isCompleted: false
            )

            WorkoutCard(
                title: "Pull Day",
                exercises: "Deadlifts, Pull-ups, Rows",
                time: "55 min",
                isCompleted: true,
                date: "Yesterday"
            )
        }
        .padding()
    }
}
