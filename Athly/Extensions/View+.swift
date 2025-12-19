//
//  View+.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
    
    func placeholder<Content: View>(when shouldShow: Bool, alignment: Alignment = .leading, @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> TupleView<(Self?, Content?)> {
        if conditional {
            return TupleView((nil, content(self)))
        } else {
            return TupleView((self, nil))
        }
    }
}

extension UIImage: @retroactive Identifiable {}

extension UIImage: @retroactive Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(contentType: .image) { image in
            image.jpegData(compressionQuality: 1.0) ?? Data()
        } importing: { data in
            UIImage(data: data) ?? UIImage()
        }
    }
}

extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
    
    static var width: Double {
        if let width = UIWindow.current?.screen.bounds.width {
            return width
        }
        print("ERROR!\nERROR!\nERROR! Width is somehow 0!")
        return 0
    }
    
    static var height: Double {
        if let height = UIWindow.current?.screen.bounds.height {
            return height
        }
        print("ERROR!\nERROR!\nERROR! Height is somehow 0!")
        return 0
    }
    
    static var bottomSafeArea: Double {
        if let height = UIWindow.current?.safeAreaInsets.bottom {
            return height
        }
        print("ERROR!\nERROR!\nERROR! Safe area inset bottom is somehow 0!")
        return 0
    }
}

extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}

struct CustomStyle: ViewModifier {
    var isEnabled: Bool
    func body(content: Content) -> some View {
        content
            .disabled(!isEnabled)
            .opacity(isEnabled ? 1 : 0.4)
    }
}

extension View {
    func enabled(_ isEnabled: Bool) -> some View {
        modifier(CustomStyle(isEnabled: isEnabled))
    }
}

