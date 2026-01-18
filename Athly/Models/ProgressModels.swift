//
//  ProgressModels.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct CategoryStat: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let workouts: Int
    let total: Int
    let color: Color
}
