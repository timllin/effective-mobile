//
//  MusicOffers.swift
//  EffectiveMobile-testcase
//
//  Created by Тимур Калимуллин on 31.05.2024.
//

import Foundation

struct MusicOffers: Decodable {
    let offers: [Offer]

    struct Offer: Decodable {
        let id: Int
        let title: String
        let town: String
        let price: Price
    }

    struct Price: Decodable {
        let value: Double
    }

}
