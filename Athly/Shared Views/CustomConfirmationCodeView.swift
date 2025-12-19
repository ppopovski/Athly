//
//  CustomConfirmationCodeView.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct CustomConfirmationCodeView: View {
    var onResendRequest: () -> Void
    var onSubmit: (String) -> Bool
    
    @State private var input: String = ""
    @State private var wrongAttempts: CGFloat = 0
    @State private var showingError = false
    @FocusState private var focusedInput: Bool
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 30) {
            HStack(spacing: 12) {
                ForEach(0..<6, id: \.self) { index in
                    let isFieldFilled = input.count > index
                    Text(isFieldFilled ? input[index] : "")
                        .foregroundStyle(.white)
                        .font(.system(size: 24, weight: .semibold))
                        .frame(width: 50, height: 60)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(CustomColor.bgBlack)
                                .strokeBorder(showingError ? CustomColor.error : isFieldFilled ? CustomColor.primary : .gray, lineWidth: 2)
                        }
                }
            }
            .background {
                TextField("hiddenInput", text: $input)
                    .keyboardType(.numberPad)
                    .focused($focusedInput)
                    .frame(width: 0.1, height: 0.1)
                    .clipped()
                    .opacity(0.0001)
                    .overlay(.white)
            }
            .modifier(Shake(animatableData: wrongAttempts))
            .sensoryFeedback(.error, trigger: wrongAttempts)
            
            HStack(spacing: 4) {
                Text("Didn't receive the code?")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.white.opacity(0.8))
                
                Button {
                    onResendRequest()
                } label: {
                    Text("Resend")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(CustomColor.primary)
                        .underline()
                }
            }
        }
        .onReceive(timer) { _ in
            focusedInput = input.count < 6
        }
        .onChange(of: input) { oldValue, newValue in
            input = newValue.filter { $0.isNumber }

            if !input.isEmpty && showingError {
                withAnimation {
                    showingError = false
                }
            }
            
            if input.count >= 6 {
                focusedInput = false
                
                if input == "000000" {
                    let _ = onSubmit(input)
                } else {
                    let success = onSubmit(input)
                    
                    if !success {
                        input = ""
                        showingError = true
                        withAnimation(.default) {
                            wrongAttempts += 1
                        }
                    }
                }
            }
        }
        .onAppear {
            focusedInput = true
        }
    }
}

#Preview {
    ZStack {
        CustomColor.bgBlack
            .ignoresSafeArea()
        
        CustomConfirmationCodeView(
            onResendRequest: {
                print("Mock: Resend requested")
            },
            onSubmit: { code in
                print("Mock: Code submitted: \(code)")
                return code == "123456" || code == "000000"
            }
        )
    }
}

fileprivate struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}
