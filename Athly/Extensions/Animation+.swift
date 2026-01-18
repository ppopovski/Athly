//
//  Animation+.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

extension Animation {
    // MARK: - Spring Animations
    static var springBouncy: Animation {
        .spring(response: 0.4, dampingFraction: 0.6)
    }
    
    static var springSmooth: Animation {
        .spring(response: 0.3, dampingFraction: 0.8)
    }
    
    static var quickSpring: Animation {
        .spring(response: 0.25, dampingFraction: 0.7)
    }
    
    static var gentleSpring: Animation {
        .spring(response: 0.5, dampingFraction: 0.85)
    }
    
    // MARK: - Easing Animations
    static var easeInOut: Animation {
        .easeInOut(duration: 0.3)
    }
    
    static var easeInOutSlow: Animation {
        .easeInOut(duration: 0.5)
    }
    
    static var easeInOutFast: Animation {
        .easeInOut(duration: 0.2)
    }
    
    // MARK: - Custom Animations
    static var cardAppear: Animation {
        .spring(response: 0.4, dampingFraction: 0.75)
    }
    
    static var buttonPress: Animation {
        .spring(response: 0.3, dampingFraction: 0.7)
    }
    
    static var listItem: Animation {
        .spring(response: 0.35, dampingFraction: 0.8)
    }
    
    static var fadeIn: Animation {
        .easeIn(duration: 0.3)
    }
    
    static var fadeOut: Animation {
        .easeOut(duration: 0.2)
    }
    
    static var scaleIn: Animation {
        .spring(response: 0.3, dampingFraction: 0.7)
    }
}

// MARK: - View Modifiers for Animations
extension View {
    func animateOnAppear(delay: Double = 0) -> some View {
        self.modifier(AnimateOnAppearModifier(delay: delay))
    }
    
    func staggerAnimation(index: Int, delay: Double = 0.05) -> some View {
        self.modifier(StaggerAnimationModifier(index: index, delay: delay))
    }
}

struct AnimateOnAppearModifier: ViewModifier {
    let delay: Double
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        content
            .opacity(hasAppeared ? 1 : 0)
            .offset(y: hasAppeared ? 0 : 20)
            .onAppear {
                withAnimation(.springSmooth.delay(delay)) {
                    hasAppeared = true
                }
            }
    }
}

struct StaggerAnimationModifier: ViewModifier {
    let index: Int
    let delay: Double
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        content
            .opacity(hasAppeared ? 1 : 0)
            .offset(x: hasAppeared ? 0 : -20)
            .onAppear {
                withAnimation(.listItem.delay(Double(index) * delay)) {
                    hasAppeared = true
                }
            }
    }
}
