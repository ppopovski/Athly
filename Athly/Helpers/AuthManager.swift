//
//  AuthManager.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

@MainActor
@Observable class AuthManager {
    static let shared = AuthManager()
    
    var userState: UserState = .loggedOut
}

enum UserState {
    case loggedOut
    case needsOnboarding
    case authenticated
}
