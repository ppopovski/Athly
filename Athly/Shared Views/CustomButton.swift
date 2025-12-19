//
//  CustomButton.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct CustomButton: View {
    var buttonText = "Continue"
    var cornerRadius: CGFloat = ButtonCornerRadius
    var lineWidth: CGFloat = ButtonBorderThickness
    var height: CGFloat = ButtonHeight
    var image: Image?
    var disabled: Bool = false
    var loading: Bool = false
    var imageOnRight: Bool = false

    var backgroundColor: Color = CustomColor.primary
    var contentsColor: Color = CustomColor.bgWhite
    var borderColor: Color = CustomColor.primary
    var disabledColor: Color = CustomColor.separators
    
    var buttonType: ButtonType = .smallPrimary
    var action: (() -> Void)
    
    var body: some View {
        Button {
            action()
        } label: {
            Group {
                viewForButtonType
            }
            .cornerRadius(cornerRadius)
            .frame(height: height)
        }
        .disabled(disabled || loading)
    }
    
    @ViewBuilder
    private var viewForButtonType: some View {
        switch buttonType {
        case .primary:
            primaryButton
        case .secondary:
            secondaryButton
        case .smallPrimary:
            smallPrimaryButton
        case .smallSecondary:
            smallSecondaryButton
        }
    }
    
    private var primaryButton: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            if loading {
                ProgressView()
                    .tint(contentsColor)
            } else {
                contentsView
            }
            Spacer(minLength: 0)
        }
        .padding()
        .foregroundStyle(contentsColor)
        .background(disabled ? disabledColor : backgroundColor)
    }
    
    private var secondaryButton: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            if loading {
                ProgressView()
                    .tint(contentsColor)
            } else {
                contentsView
            }
            Spacer(minLength: 0)
        }
        .padding()
        .foregroundStyle(contentsColor)
        .background(disabled ? disabledColor : backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(disabled ? .clear : borderColor, lineWidth: lineWidth)
        )
        .padding(lineWidth/2)
    }
    
    private var smallPrimaryButton: some View {
        HStack(spacing: 0) {
            ZStack {
                contentsView
                    .opacity(loading ? 0 : 1)
                ProgressView()
                    .tint(contentsColor)
                    .opacity(loading ? 1 : 0)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
        }
        .foregroundStyle(contentsColor)
        .background(disabled ? disabledColor : backgroundColor)
    }
    
    private var smallSecondaryButton: some View {
        HStack(spacing: 0) {
            ZStack {
                contentsView
                    .opacity(loading ? 0 : 1)
                ProgressView()
                    .tint(contentsColor)
                    .opacity(loading ? 1 : 0)
                
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
        }
        .foregroundStyle(contentsColor)
        .background(disabled ? disabledColor : backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(disabled ? .clear : borderColor, lineWidth: lineWidth)
        )
        .padding(lineWidth/2)
    }
    
    @ViewBuilder
    private var contentsView: some View {
        if imageOnRight {
            HStack {
                buttonTextView
                image
            }
        } else {
            HStack {
                image
                buttonTextView
            }
        }
    }
    
    private var buttonTextView: some View {
        Text(buttonText)
            .font(.system(size: 16, weight: .medium))
    }
}

#Preview {
    ScrollView {
        VStack {
            Group {
                CustomButton(buttonText: "Button", image: Image(systemName: "star"), disabled: false, loading: false, buttonType: .primary) {
                }
                CustomButton(buttonText: "Button", image: Image(systemName: "star"), disabled: false, loading: true, buttonType: .primary) {
                }
                CustomButton(buttonText: "Button", image: Image(systemName: "star"), disabled: true, loading: false, buttonType: .primary) {
                }
            }
            Group {
                CustomButton(buttonText: "Button", image: Image(systemName: "star"), disabled: false, loading: false, backgroundColor: CustomColor.bgWhite, contentsColor: CustomColor.primary, buttonType: .secondary) {
                }
                CustomButton(buttonText: "Button", image: Image(systemName: "star"), disabled: false, loading: true, backgroundColor: CustomColor.bgWhite, contentsColor: CustomColor.primary, buttonType: .secondary) {
                }
                CustomButton(buttonText: "Button", image: Image(systemName: "star"), disabled: true, loading: false, backgroundColor: CustomColor.bgWhite, contentsColor: CustomColor.primary, buttonType: .secondary) {
                }
            }
            Group {
                CustomButton(buttonText: "Button", image: Image(systemName: "star"), disabled: false, loading: false, buttonType: .smallPrimary) {
                }
                CustomButton(buttonText: "Button", image: Image(systemName: "star"), disabled: false, loading: true, buttonType: .smallPrimary) {
                }
                CustomButton(buttonText: "Button", image: Image(systemName: "star"), disabled: true, loading: false, buttonType: .smallPrimary) {
                }
            }
            Group {
                CustomButton(buttonText: "Button", image: Image(systemName: "star"), disabled: false, loading: false, backgroundColor: CustomColor.bgWhite, contentsColor: CustomColor.primary,  buttonType: .smallSecondary) {
                }
                CustomButton(buttonText: "Button", image: Image(systemName: "star"), disabled: false, loading: true, backgroundColor: CustomColor.bgWhite, contentsColor: CustomColor.primary,  buttonType: .smallSecondary) {
                }
                CustomButton(buttonText: "Button", image: Image(systemName: "star"), disabled: true, loading: false, backgroundColor: CustomColor.bgWhite, contentsColor: CustomColor.primary,  buttonType: .smallSecondary) {
                }
            }
        }
    }
}

enum ButtonType {
    case primary
    case secondary
    case smallPrimary
    case smallSecondary
}

