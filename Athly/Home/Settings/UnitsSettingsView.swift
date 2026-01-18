//
//  UnitsSettingsView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct UnitsSettingsView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @Environment(\.dismiss) private var dismiss
    @Environment(UnitsSettingsViewModel.self) private var viewModel

    var body: some View {
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    weightSection
                    distanceSection

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(CustomColor.primary)
            }

            Spacer()
        }
        .padding(.top, 10)

        VStack(alignment: .leading, spacing: 8) {
            Text("Units")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(CustomColor.primary)

            Text("Choose your measurement preferences")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.top, 10)
    }

    @ViewBuilder
    private var weightSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weight")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white.opacity(0.5))
                .textCase(.uppercase)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                ForEach(WeightUnit.allCases, id: \.self) { unit in
                    UnitRow(
                        title: unit.rawValue,
                        isSelected: viewModel.weightUnit == unit,
                        action: {
                            viewModel.selectWeightUnit(unit)
                        }
                    )

                    if unit != WeightUnit.allCases.last {
                        Divider().background(Color.white.opacity(0.1))
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }

    @ViewBuilder
    private var distanceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Distance")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white.opacity(0.5))
                .textCase(.uppercase)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                ForEach(DistanceUnit.allCases, id: \.self) { unit in
                    UnitRow(
                        title: unit.rawValue,
                        isSelected: viewModel.distanceUnit == unit,
                        action: {
                            viewModel.selectDistanceUnit(unit)
                        }
                    )

                    if unit != DistanceUnit.allCases.last {
                        Divider().background(Color.white.opacity(0.1))
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
            )
        }
    }

}

struct UnitRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(CustomColor.primary)
                        .font(.system(size: 20))
                }
            }
            .padding(16)
        }
    }
}

#Preview {
    NavigationStack {
        UnitsSettingsView()
            .environment(NavigationCoordinator())
    }
}
