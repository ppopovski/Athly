//
//  SplashView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct SplashView: View {
    @Environment(NavigationCoordinator.self) private var coordinator

    @State private var animateLogo = false
    @State private var showContent = false

    let splashScreenDuration = 1.0
    
    var body: some View {
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()

            VStack {
                Image(.athlyLogo)
                    .resizable()
                    .frame(width: 110, height: 124)
                    .scaleEffect(animateLogo ? 1.3 : 1.5)
                    .animation(.interpolatingSpring(stiffness: 100, damping: 10), value: animateLogo)

                if showContent {
                    Spacer()
                    
                    buttonsView
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .animation(.easeIn(duration: 0.5), value: showContent)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 80)
        }
        .navigationBarHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + splashScreenDuration) {
                animateLogo = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation {
                        showContent = true
                    }
                }
            }
        }
    }

    var buttonsView: some View {
        VStack(spacing: 12) {
            CustomButton(buttonText: "Log In", cornerRadius: ButtonCornerRadius, backgroundColor: CustomColor.bgBlack, contentsColor: CustomColor.primary, buttonType: .secondary) {
                coordinator.push(WelcomeScreen.login)
            }

            CustomButton(buttonText: "Create an Account", cornerRadius: ButtonCornerRadius, backgroundColor: CustomColor.primary, contentsColor: CustomColor.bgBlack, buttonType: .primary) {
                coordinator.push(WelcomeScreen.register)
            }
        }
    }
}

#Preview {
    SplashView()
        .environment(NavigationCoordinator())
}
