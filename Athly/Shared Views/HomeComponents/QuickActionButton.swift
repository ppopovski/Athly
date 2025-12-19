//
//  QuickActionButton.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(color)

                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

#Preview {
    ZStack {
        CustomColor.bgBlack.ignoresSafeArea()

        HStack(spacing: 12) {
            QuickActionButton(
                icon: "plus.circle.fill",
                title: "New Workout",
                color: CustomColor.primary
            ) {
                print("New workout tapped")
            }

            QuickActionButton(
                icon: "chart.bar.fill",
                title: "Progress",
                color: CustomColor.primary.opacity(0.8)
            ) {
                print("Progress tapped")
            }
        }
        .padding()
    }
}
