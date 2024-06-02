//
//  SwiftUIView.swift
//  EffectiveMobile-testcase
//
//  Created by Тимур Калимуллин on 02.06.2024.
//

import SwiftUI

struct AdaptiveLabelStyle: LabelStyle {
    @Binding var isNeededIcon: Bool

    func makeBody(configuration: Configuration) -> some View {
        if isNeededIcon {
            // 1
            HStack {
                configuration.icon
                configuration.title
            }
        } else {
            VStack {
                configuration.title
            }
        }
    }
}
