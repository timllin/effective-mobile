//
//  TicketOffers.swift
//  EffectiveMobile-testcase
//
//  Created by Тимур Калимуллин on 01.06.2024.
//

import Foundation

struct TicketOffers: Decodable {
    let ticketsOffers: [TicketOffer]

    enum CodingKeys: String, CodingKey {
        case ticketsOffers = "tickets_offers"
    }

    struct TicketOffer: Decodable {
        let id: Int
        let title: String
        let timeRange: [String]
        let price: Price

        enum CodingKeys: String, CodingKey {
            case id, title
            case timeRange = "time_range"
            case price
        }
    }

    struct Price: Decodable {
        let value: Double
    }

}

