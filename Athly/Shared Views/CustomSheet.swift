//
//  CustomSheet.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

fileprivate struct RemoveSheetShadow: UIViewRepresentable {
    var shouldDismissOnOutsideTap: Bool = true
    @Environment(\.dismiss) private var dismiss
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        if shouldDismissOnOutsideTap {
            let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
            view.addGestureRecognizer(tapGesture)
        }
        
        DispatchQueue.main.async {
            if let shadowView = view.dropShadowView {
                shadowView.layer.shadowColor = UIColor.clear.cgColor
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(dismiss: dismiss)
    }
    
    class Coordinator {
        let dismiss: DismissAction
        
        init(dismiss: DismissAction) {
            self.dismiss = dismiss
        }
        
        @objc func handleTap() {
            dismiss()
        }
    }
}

extension UIView {
    var dropShadowView: UIView? {
        if let superview, String(describing: type(of: superview)) == "UIDropShadowView" {
            return superview
        }
        return superview?.dropShadowView
    }
}

struct TrayConfig {
    var maxDetent: PresentationDetent = .fraction(0.999)
    var cornerRadius: CGFloat = 15
    var isInteractiveDismissDisabled: Bool = false
    var horizontalPadding: CGFloat = 0
    var bottomPadding: CGFloat = 0
    var shouldDismissOnOutsideTap: Bool = true
    var backgroundColor: Color = Color(UIColor.systemBackground)
    var isFloating: Bool = false
    var showDragIndicator: Bool = true
}

extension View {
    @ViewBuilder
    func customSheet<Content: View>(
        isPresented show: Binding<Bool>,
        config: TrayConfig = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        @Environment(\.dismiss) var dismiss
        
        self
            .sheet(isPresented: show) {
                content()
                    .background {
                        if config.showDragIndicator {
                            DragIndicator()
                                .frame(maxHeight: .infinity, alignment: .top)
                        }
                    }
                    .background(config.backgroundColor)
                    .clipShape(.rect(cornerRadius: config.cornerRadius))
                    .padding(.horizontal, config.horizontalPadding)
                    .padding(.bottom, config.bottomPadding)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .presentationDetents([config.maxDetent])
                    .presentationCornerRadius(0)
                    .presentationBackground(.clear)
                    .presentationDragIndicator(.hidden)
                    .interactiveDismissDisabled(config.isInteractiveDismissDisabled)
                    .background(RemoveSheetShadow(shouldDismissOnOutsideTap: config.shouldDismissOnOutsideTap))
                    .background {
                        if !config.isFloating {
                            VStack(spacing: 0) {
                                Spacer(minLength: 0)
                                Color(config.backgroundColor)
                                    .padding(.bottom, -UIScreen.bottomSafeArea - config.bottomPadding)
                                    .padding(.horizontal, config.horizontalPadding)
                                    .frame(height: UIScreen.bottomSafeArea + config.bottomPadding)
                            }
                        }
                    }
            }
    }
}

struct DragIndicator: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.secondary)
            .frame(width: 36, height: 5)
            .padding(.top, 8)
    }
}

#Preview {
    Color(.blue)
        .ignoresSafeArea()
        .customSheet(isPresented: .constant(true)) {
            Color(.red)
                .frame(height: 300)
        }
}

