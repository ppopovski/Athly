//
//  SettingsRow.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

enum SettingsRowAccessory {
    case chevron
    case toggle(Binding<Bool>)
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let accessory: SettingsRowAccessory
    let action: () -> Void

    init(
        icon: String,
        title: String,
        subtitle: String,
        accessory: SettingsRowAccessory = .chevron,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.accessory = accessory
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(CustomColor.primary)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)

                    Text(subtitle)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.6))
                }

                Spacer()

                accessoryView
            }
            .padding(16)
        }
        .disabled(isToggle)
    }

    @ViewBuilder
    private var accessoryView: some View {
        switch accessory {
        case .chevron:
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.3))

        case .toggle(let binding):
            Toggle("", isOn: binding)
                .labelsHidden()
                .tint(CustomColor.primary)
                .onTapGesture {
                    // Prevent the button action when tapping the toggle
                }
        }
    }

    private var isToggle: Bool {
        if case .toggle = accessory {
            return true
        }
        return false
    }
}

#Preview {
    ZStack {
        CustomColor.bgBlack.ignoresSafeArea()

        SettingsRow(
            icon: "person.circle.fill",
            title: "Profile",
            subtitle: "Edit your profile information"
        ) {
            print("Profile tapped")
        }
    }
}
