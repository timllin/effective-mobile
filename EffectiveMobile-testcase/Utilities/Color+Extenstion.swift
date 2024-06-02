//
//  Color+Extenstion.swift
//  EffectiveMobile-testcase
//
//  Created by Тимур Калимуллин on 31.05.2024.
//

import Foundation
import SwiftUI

// MARK: Basic Colors
extension Color {
    static let basic = Color.Basic()

    struct Basic {
        let black = Color("black")
        let grey1 = Color("grey1")
        let grey2 = Color("grey2")
        let grey3 = Color("grey3")
        let grey4 = Color("grey4")
        let grey5 = Color("grey5")
        let grey6 = Color("grey6")
        let grey7 = Color("grey7")
        let white = Color("white")
    }
}

// MARK: Special Colors
extension Color {
    static let special = Color.Special()

    struct Special {
        let blue = Color("blue")
        let darkBlue = Color("darkBlue")
        let green = Color("green")
        let darkGreen = Color("darkGreen")
        let orange = Color("orange")
        let red = Color("red")
    }
}
