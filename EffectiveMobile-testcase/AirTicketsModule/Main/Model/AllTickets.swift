//
//  AllTickets.swift
//  EffectiveMobile-testcase
//
//  Created by Тимур Калимуллин on 02.06.2024.
//

import Foundation

struct AllTickets: Decodable {
    let tickets: [Ticket]

    struct Ticket: Decodable {
        let id: Int
        let badge: String?
        let price: Price
        let departure: Departure
        let arrival: Arrival
        let hasTransfer: Bool

        enum CodingKeys: String, CodingKey {
            case id, badge, price, departure, arrival
            case hasTransfer = "has_transfer"
        }
    }

    struct Price: Decodable {
        let value: Double
    }

    struct Departure: Decodable {
        let date: String
        let airport: String
    }

    struct Arrival: Decodable {
        let date: String
        let airport: String
    }
}
