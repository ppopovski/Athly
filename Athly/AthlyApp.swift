//
//  AthlyApp.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import UIKit
import UserNotifications

@main
struct AthlyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .preferredColorScheme(.light)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        UNUserNotificationCenter.current().delegate = self
        AuthManager.shared.setupAuthStateListener()

        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.badge, .banner, .list, .sound]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print(response)
        if let model = response.notification.request.content.userInfo["model"] as? [String: Any] {
            if let destination = model["destination"] as? String, let destinationUrl = URL(string: destination) {
                await UIApplication.shared.open(destinationUrl)
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.base64EncodedString()

        print("device token is \(token)")
        // apnsTokenEnvironment should be .production if on TestFlight
//        let apnsTokenEnvironment: ApnsTokenEnvironment = {
//#if DEBUG
//            return .sandbox
//#else
//            return .production
//#endif
//        }()
//        Task {
//            try await ApiClient.api.notification.token(input: .init(tokenType: .apns, apnsTokenEnvironment: apnsTokenEnvironment, token: token))
//        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

