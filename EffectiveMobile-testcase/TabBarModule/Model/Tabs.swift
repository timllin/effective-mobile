//
//  Tabs.swift
//  EffectiveMobile-testcase
//
//  Created by Тимур Калимуллин on 02.06.2024.
//

import Foundation

enum Tabs: CaseIterable {
    case airTicket
    case hotel
    case briefly
    case subscriptions
    case profile

    var item: TabItem {
        switch self {
        case .airTicket: 
            return .init(title: "Авиабилеты", imageName: "airplane")
        case .hotel:
            return .init(title: "Отели", imageName: "hotel")
        case .briefly:
            return .init(title: "Короче", imageName: "location")
        case .subscriptions:
            return .init(title: "Подписки", imageName: "bell")
        case .profile:
            return .init(title: "Профиль", imageName: "person")
        }
    }
}
