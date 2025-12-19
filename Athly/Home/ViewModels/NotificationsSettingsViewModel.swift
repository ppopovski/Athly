//
//  NotificationsSettingsViewModel.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

@Observable
class NotificationsSettingsViewModel {
    var workoutReminders = true
    var progressUpdates = true
    var achievements = true
    var weeklyReports = false
    var socialActivity = true
    
    func saveSettings() {
        // TODO: Save notification settings to UserDefaults or Firebase
    }
}
