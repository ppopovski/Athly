//
//  PasswordChangedView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct PasswordChangedView: View {
    @Environment(ForgotPasswordViewModel.self) private var viewModel
    @Environment(NavigationCoordinator.self) private var coordinator

    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(CustomColor.primary.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(CustomColor.primary)
            }
            .padding(.bottom, 20)
            
            VStack(spacing: 12) {
                Text("Password Changed!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(CustomColor.primary)
                
                Text("Your password has been changed successfully.")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
            
            CustomButton(
                buttonText: "Back to Login",
                cornerRadius: ButtonCornerRadius,
                buttonType: .primary
            ) {
                coordinator.pop(steps: 4)
            }
            .padding(.horizontal)
        }
        .padding()
        .background {
            Color.clear
                .contentShape(Rectangle())
        }
        .navigationBarHidden(true)
        .interactiveDismissDisabled()
    }
}

#Preview {
    NavigationStack {
        ZStack {
            CustomColor.bgBlack.ignoresSafeArea()
            PasswordChangedView()
                .environment(ForgotPasswordViewModel())
        }
    }
}
