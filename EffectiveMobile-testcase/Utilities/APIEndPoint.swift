//
//  APIEndPoint.swift
//  EffectiveMobile-testcase
//
//  Created by Тимур Калимуллин on 31.05.2024.
//

import Foundation

protocol APIBuilder {
    var urlRequest: URLRequest { get }
    var baseUrl: URL { get }
    var path: String { get }
}

enum APIEndPoint {
    case getMusicOffers
    case getTicketOffers
    case getAllTickets
}


extension APIEndPoint: APIBuilder {

    var baseUrl: URL {
        switch self {
        case .getMusicOffers, .getTicketOffers, .getAllTickets:
            return URL(string: "https://run.mocky.io/v3/")!
        }
    }

    var path: String {
        switch self {
        case .getMusicOffers:
            return "214a1713-bac0-4853-907c-a1dfc3cd05fd"
        case .getTicketOffers:
            return "7e55bf02-89ff-4847-9eb7-7d83ef884017"
        case .getAllTickets:
            return "670c3d56-7f03-4237-9e34-d437a9e56ebf"
        }
    }

    var urlRequest: URLRequest {
        switch self {
        case .getMusicOffers, .getTicketOffers, .getAllTickets:
            return URLRequest(url: self.baseUrl.appendingPathComponent(self.path))
        }
    }
}


