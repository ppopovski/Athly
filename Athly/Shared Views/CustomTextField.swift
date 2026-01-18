//
//  CustomTextField.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

struct CustomTextField: View {
    enum Style {
        case standard
        case compact
        case line
    }
    
    var title: any StringProtocol
    @Binding var text: String
    var isSecure: Bool = false
    var isMultiline: Bool = false
    var wordLimit: Int?
    var imageResource: ImageResource? = nil
    var systemImage: String? = nil
    var style: Style = .standard
    var cornerRadius = TextFieldCornerRadius
    var descriptionText = false
    var updateTransition: AnyTransition? = nil
    var trailingView: AnyView? = nil
    var placeholderColor: Color? = nil
    var backgroundColor: Color? = nil
    var textColor: Color = .white
    
    // Error handling
    var inputValidator: CustomTextInputValidator? = nil
    @State private var error: CustomTextInputValidator.ValidationError? = nil
    
    @State private var isMasked: Bool = true
    @FocusState private var isFocused: Bool
    @State private var isFocusedWrapped: Bool = false
    @State private var wordsCount: Int = 0
    @State private var isEmpty = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if style == .line {
                if !isEmpty || isFocused {
                    Text(title)
                        .font(.custom(size: 12))
                        .foregroundColor(.white)
                        .transition(.opacity)
                }

                HStack {
                    TFImage
                    TFView
                        .focused($isFocused)
                        .font(.custom(size: 18))
                        .foregroundColor(.white)

                    if isSecure {
                        Spacer()
                        RevealButton.frame(height: 23)
                    }

                    if let trailingView {
                        trailingView
                    }
                }

                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(error != nil ? .red : CustomColor.primary)
            } else {
                VStack(spacing: 0) {
                    if !isEmpty && descriptionText {
                        Text(title)
                            .font(.custom(size: 12))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    HStack {
                        TFImage
                        TFView
                            .if(updateTransition != nil) { tf in
                                tf.transition(updateTransition ?? .opacity).id(text)
                            }
                            .focused($isFocused)

                        if isSecure {
                            Spacer()
                            RevealButton.frame(height: 23)
                        }

                        if let trailingView {
                            trailingView
                        }
                    }
                    .font(.custom(size: 18))
                    .frame(maxWidth: .infinity)

                    if let wordLimit {
                        HStack {
                            Spacer()
                            Text("\(wordsCount) / \(wordLimit)")
                                .font(.custom(size: 12))
                                .foregroundStyle(wordsCount <= wordLimit ? .gray : .red)
                        }
                        .offset(y: 6)
                    }
                }
                .padding(style == .standard ? 16 : 8)
                .padding(.horizontal, style == .compact ? 6 : 0)
                .background {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(backgroundColor ?? Color.white)
                        .stroke(Outline)
                        .shadow(color: (isFocusedWrapped || error != nil) ? Outline.opacity(0.7) : .clear, radius: 1)
                }
                .contentShape(.rect)
                .onTapGesture {
                    isFocused = true
                }
            }

            if let error {
                Text(error.message)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.red)
                    .font(.custom(size: 12, weight: .medium))
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .onChange(of: text) {
            withAnimation {
                isEmpty = text.isEmpty
            }
            wordsCount = currentWordCount
        }
        .onChange(of: isFocused) {
            withAnimation {
                isFocusedWrapped = isFocused
                if isFocused { error = nil }
                else { error = inputValidator?.isValid(text) }
            }
        }
        .onAppear { wordsCount = currentWordCount }
    }

    private var currentWordCount: Int {
        guard wordLimit != nil else { return 0 }
        let components = text.components(separatedBy: .whitespacesAndNewlines)
        let words = components.filter { !$0.isEmpty }
        return words.count
    }

    private var Outline: Color {
        if isFocusedWrapped {
            CustomColor.primary
        } else if error != nil {
            Color.red
        } else {
            Color.gray
        }
    }
    
    @ViewBuilder private var TFView: some View {
        let placeholder = Text(title)
            .foregroundColor(placeholderColor ?? .gray.opacity(0.5))

        if isSecure && isMasked {
            SecureField("", text: $text, prompt: placeholder)
                .foregroundColor(textColor)
        } else if isMultiline {
            TextField("", text: $text, prompt: placeholder, axis: .vertical)
                .foregroundColor(textColor)
        } else {
            TextField("", text: $text, prompt: placeholder)
                .foregroundColor(textColor)
                .if(isSecure) { field in
                    field.textInputAutocapitalization(.never)
                         .keyboardType(.asciiCapable)
                }
        }
    }
    
    @ViewBuilder private var TFImage: some View {
        if let imageResource {
            Image(imageResource)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
        } else if let systemImage {
            Image(systemName: systemImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder private var RevealButton: some View {
        Button {
            let wasFocused = isFocused
            
            withAnimation {
                isMasked.toggle()
                
                Task {
                    try? await Task.sleep(nanoseconds: 100_000_000)
                    isFocused = wasFocused // return focus after switching between masked/unmasked password
                }
            }
        } label: {
            Image(systemName: isMasked ? "eye" : "eye.slash")
                .foregroundStyle(CustomColor.primary)
        }
    }
}

#Preview {
    @Previewable @State var longText = "Lorem ipsum dolor sit amet consect- etur. In porta tellus duis sed nulla in. Quisque tortor ut ac at."
    @Previewable @State var password = "password"
    @Previewable @State var text = ""
    @Previewable @State var sampleText = "Sample"

    VStack(spacing: 30) {
        CustomTextField(title: "Enter text", text: $text, descriptionText: true)
        CustomTextField(title: "Enter text", text: $text)

        CustomTextField(title: "Enter text", text: $sampleText)
        CustomTextField(title: "Enter text", text: $longText, isMultiline: true, wordLimit: 30)
        
        CustomTextField(title: "Enter password", text: .constant(""), isSecure: true)
        CustomTextField(title: "Enter password", text: $password, isSecure: true)
        
    }
    .padding()
}

