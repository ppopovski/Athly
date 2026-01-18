//
//  AuthManager.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI
import FirebaseAuth

@MainActor
@Observable class AuthManager {
    static let shared = AuthManager()
    
    var userState: UserState = .loggedOut
    var currentUser: User? = nil
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    private init() {
        if let user = Auth.auth().currentUser {
            self.currentUser = user
            self.userState = .authenticated
        }
    }
    
    func setupAuthStateListener() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.currentUser = user
                if let user = user {
                    if let userId = user.uid.data(using: .utf8) {
                        KeychainHelper.save(userId, forKey: "firebaseUserId")
                    }
                    self?.userState = .authenticated
                } else {
                    KeychainHelper.delete(forKey: "firebaseUserId")
                    self?.userState = .loggedOut
                }
            }
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        currentUser = nil
        userState = .loggedOut
    }
    
    func getUserId() -> String? {
        return currentUser?.uid
    }
}

enum UserState {
    case loggedOut
    case needsOnboarding
    case authenticated
}
