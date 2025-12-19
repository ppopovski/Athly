//
//  UnitsSettingsViewModel.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

enum WeightUnit: String, CaseIterable {
    case kilograms = "Kilograms (kg)"
    case pounds = "Pounds (lbs)"
}

enum DistanceUnit: String, CaseIterable {
    case kilometers = "Kilometers (km)"
    case miles = "Miles (mi)"
}

@Observable
class UnitsSettingsViewModel {
    var weightUnit: WeightUnit = .kilograms
    var distanceUnit: DistanceUnit = .kilometers
    
    func selectWeightUnit(_ unit: WeightUnit) {
        weightUnit = unit
        saveSettings()
    }

    func selectDistanceUnit(_ unit: DistanceUnit) {
        distanceUnit = unit
        saveSettings()
    }

    private func saveSettings() {
        // TODO: Save unit settings to UserDefaults or Firebase
    }
}
