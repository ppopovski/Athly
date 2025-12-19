//
//  ProjectConstants.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import SwiftUI

let FontName: String = ""
let ButtonCornerRadius: CGFloat = 25
let ButtonHeight: CGFloat = 54
let ButtonBorderThickness: CGFloat = 2

let TextFieldCornerRadius: CGFloat = 16

// MARK: - Project Colors
struct CustomColor {
    static let primary = Color.hex("#0CBE65")
    static let primaryLight01 = Color.hex("#343434")
    static let primaryLight02 = Color.hex("#D9D9D9")
    static let primaryButtonText = Color.hex("#262626")
    static let bgBlack = Color.hex("#1D2A33")
    static let bgWhite = Color.hex("#FFFFFF")
    static let secondaryButtonText = Color.hex("#222222")
    static let cardBackground = Color.hex("#242424")
    static let separators = Color.hex("#D0D0D0")
    static let secondaryText = Color.hex("#999999")
    static let disabledButtonGrey = Color.hex("#DDDDDD")
    static let accent = Color.hex("#9747FF")
    static let accent02 = Color.hex("#5A2A93")
    static let link = Color.hex("#3697F0")
    static let error = Color.hex("#FB574D")
    static let medium = Color.hex("#FBD424")
    static let success = Color.hex("#59CCAD")
}

extension Color {
    /// We add all colors from figma here, and use only these
    
    /// Choose one
    // Hex initilizers
    //    static let primary1 = Color.hex("#<#T##HexCodeString##String#>")
    //    static let primary2 = Color.hex("#<#T##HexCodeString##String#>")
    //    static let primary3 = Color.hex("#<#T##HexCodeString##String#>")
    //    static let primary4 = Color.hex("#<#T##HexCodeString##String#>")
    //    static let primary5 = Color.hex("#<#T##HexCodeString##String#>")
    
    // RGB initilizers
        static let productGreen = Color.rgb(157, 199, 60)
    static let productBlue = Color.rgb(0, 0, 255)
        static let productDarkDrey = Color.rgb(65, 64, 66)
        static let productTextfieldBackground = Color.rgb(220, 220, 220)
        static let productOffWhite = Color.rgb(235, 235, 235)
    //    static let primary4 = Color.rgb(<#T##red: Int##Int#>, <#T##green: Int##Int#>, <#T##blue: Int##Int#>)
    //    static let primary5 = Color.rgb(<#T##red: Int##Int#>, <#T##green: Int##Int#>, <#T##blue: Int##Int#>)

    
    /// If we support an app with both light and dark themes, we can include dynamic colors depending on the active theme.
    /// We'll need to define the colors for both themes, and pass them into the function getThemeColor
    /// Example:
    /// ```
    ///    static let primaryBackgroundLight = Color.rgb(240, 240, 240)
    ///    static let primaryBackgroundDark = Color.rgb(20, 20, 20)
    ///
    ///    static let primaryBackground = getThemeColor(light: primaryBackgroundLight, dark: primaryBackgroundDark)
    ///
    ///    static func getThemeColor(light: Color, dark: Color) -> Color {
    ///        let dynamicColor = Color(UIColor { traitCollection in
    ///            return traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
    ///        })
    ///        return dynamicColor
    ///    }
    /// ```
}
