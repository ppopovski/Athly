//
//  UnitsSettingsViewModel.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

@MainActor
@Observable
class UnitsSettingsViewModel {
    var weightUnit: WeightUnit = .kilograms {
        didSet {
            saveSettings()
        }
    }
    var distanceUnit: DistanceUnit = .kilometers {
        didSet {
            saveSettings()
        }
    }

    init() {
        loadSettings()
    }

    func selectWeightUnit(_ unit: WeightUnit) {
        weightUnit = unit
    }

    func selectDistanceUnit(_ unit: DistanceUnit) {
        distanceUnit = unit
    }

    private func saveSettings() {
        UserDefaults.standard.set(weightUnit.rawValue, forKey: "weightUnit")
        UserDefaults.standard.set(distanceUnit.rawValue, forKey: "distanceUnit")
    }

    private func loadSettings() {
        if let weightUnitString = UserDefaults.standard.string(forKey: "weightUnit"),
           let weightUnit = WeightUnit(rawValue: weightUnitString) {
            self.weightUnit = weightUnit
        }
        if let distanceUnitString = UserDefaults.standard.string(forKey: "distanceUnit"),
           let distanceUnit = DistanceUnit(rawValue: distanceUnitString) {
            self.distanceUnit = distanceUnit
        }
    }
}
