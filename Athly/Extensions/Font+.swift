//
//  Font+.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

extension Font {
    
    /// To add fonts, add the font files to the Fonts folder, and add the name of the font in the placeholders below.

    enum FontWeight: String {
        case extraBold = "<#T##Font name##String#>-ExtraBold"
        case extraBoldItalic = "<#T##Font name##String#>-ExtraBoldItalic"
        
        case bold = "<#T##Font name##String#>-Bold"
        case boldItalic = "<#T##Font name##String#>-BoldItalic"

        case semiBold = "<#T##Font name##String#>-SemiBold"
        case semiBoldItalic = "<#T##Font name##String#>-SemiBoldItalic"
        
        case medium = "<#T##Font name##String#>-Medium"
        case mediumItalic = "<#T##Font name##String#>-MediumItalic"
        
        case regular = "<#T##Font name##String#>-Regular"

        case light = "<#T##Font name##String#>-Light"
        case lightItalic = "<#T##Font name##String#>-LightItalic"
        
        case extraLight = "<#T##Font name##String#>-ExtraLight"
        case extraLightItalic = "<#T##Font name##String#>-ExtraLightItalic"
        
        case italic = "<#T##Font name##String#>-Italic"
    }
    
    static func customFont(_ family: FontWeight, _ size: CGFloat) -> Font {
        return .custom(family.rawValue, size: size)
    }
    
    static func customFont(_ size: CGFloat) -> Font {
        return .custom(FontWeight.regular.rawValue, size: size)
    }
}

extension Font {
    static func custom(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        let fontFamily = "Satoshi"
        
        switch weight {
        case .bold:
            fontName = "\(fontFamily)-Bold"
        case .semibold:
            fontName = "\(fontFamily)-SemiBold"
        case .medium:
            fontName = "\(fontFamily)-Medium"
        case .regular:
            fontName = "\(fontFamily)-Regular"
        case .light:
            fontName = "\(fontFamily)-Light"
        case .thin:
            fontName = "\(fontFamily)-Thin"
        default:
            fontName = "\(fontFamily)-Regular"
        }
        
        return .custom(fontName, size: size)
    }
}

