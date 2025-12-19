//
//  AuthNavigationCoordinator.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

// MARK: - Navigation Coordinator (Single coordinator for all flows)

@Observable
class NavigationCoordinator {
    var path = NavigationPath()

    func push<T: Hashable>(_ screen: T) {
        path.append(screen)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func pop(steps: Int) {
        guard path.count >= steps else {
            popToRoot()
            return
        }
        for _ in 0..<steps {
            path.removeLast()
        }
    }

    func popToRoot() {
        path = NavigationPath()
    }

    func replace<T: Hashable>(with screen: T) {
        pop()
        push(screen)
    }
}

// MARK: - Welcome Flow Screens (Splash, Login, Register, Forgot Password)

enum WelcomeScreen: Hashable {
    case login
    case register
    case forgotPassword
    case verificationCode
    case newPassword
    case passwordChanged
}

// MARK: - Home Flow Screens (After Authentication)

enum HomeScreen: Hashable {
    case settings
    case emailSettings
    case changePassword
    case notificationsSettings
    case unitsSettings
    case about
    case privacyPolicy
    case termsOfService
    case workoutDetail(WorkoutData)
    case allWorkouts
    case addWorkout
    case progress
}
