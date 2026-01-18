//
//  AuthenticatedView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct AuthenticatedView: View {
    @Environment(NavigationCoordinator.self) private var coordinator
    @State private var selectedTab = 0
    
    @State private var homeViewModel = HomeViewModel()
    @State private var calendarViewModel = CalendarViewModel()
    @State private var emailSettingsViewModel = EmailSettingsViewModel()
    @State private var changePasswordViewModel = ChangePasswordViewModel()
    @State private var unitsSettingsViewModel = UnitsSettingsViewModel()
    @State private var addWorkoutViewModel = AddWorkoutViewModel()
    @State private var allWorkoutsViewModel = AllWorkoutsViewModel()
    @State private var progressViewModel = ProgressViewModel()

    var body: some View {
        @Bindable var coordinator = coordinator

        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            NavigationStack(path: $coordinator.path) {
                CustomTabBarContainer(
                    selectedTab: $selectedTab,
                    tabs: [
                        TabBarItem(id: 0, icon: "house.fill", title: "Home"),
                        TabBarItem(id: 1, icon: "calendar", title: "Calendar"),
                        TabBarItem(id: 2, icon: "gearshape.fill", title: "Settings")
                    ]
                ) { tab in
                    Group {
                        switch tab {
                        case 0:
                            HomeView()
                        case 1:
                            CalendarView()
                        case 2:
                            SettingsView()
                        default:
                            HomeView()
                        }
                    }
                }
                .navigationDestination(for: HomeScreen.self) { screen in
                    HomeScreenView(screen: screen)
                }
            }
            .environment(homeViewModel)
            .environment(calendarViewModel)
            .environment(emailSettingsViewModel)
            .environment(changePasswordViewModel)
            .environment(unitsSettingsViewModel)
            .environment(addWorkoutViewModel)
            .environment(allWorkoutsViewModel)
            .environment(progressViewModel)
        }
        .customSheet(
            isPresented: .constant(!(NetworkMonitor.shared.isConnected ?? true)),
            config: .init(
                isInteractiveDismissDisabled: true,
                horizontalPadding: 16,
                backgroundColor: .clear,
                isFloating: true,
                showDragIndicator: false
            )
        ) {
            NoInternetView()
        }
    }
}

struct HomeScreenView: View {
    let screen: HomeScreen

    var body: some View {
        switch screen {
        case .settings:
            SettingsView()
        case .emailSettings:
            EmailSettingsView()
        case .changePassword:
            ChangePasswordView()
        case .unitsSettings:
            UnitsSettingsView()
        case .about:
            AboutView()
        case .privacyPolicy:
            PrivacyPolicyView()
        case .termsOfService:
            TermsOfServiceView()
        case .workoutDetail(let workout):
            WorkoutDetailView(workout: workout)
        case .allWorkouts:
            AllWorkoutsView()
        case .addWorkout:
            AddWorkoutView()
        case .progress:
            ProgressView()
        }
    }
}

#Preview {
    AuthenticatedView()
        .environment(NavigationCoordinator())
}
