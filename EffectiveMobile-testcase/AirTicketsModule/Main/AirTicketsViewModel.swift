//
//  AirTicketsViewModel.swift
//  EffectiveMobile-testcase
//
//  Created by Тимур Калимуллин on 31.05.2024.
//

import Foundation
import Combine

final class AirTicketsViewModel: ObservableObject {
    @Published private(set) var musicOffers = [MusicOffers.Offer]()
    @Published private(set) var ticketOffers = [TicketOffers.TicketOffer]()
    @Published private(set) var allTickets = [AllTickets.Ticket]()

    private var cancellables = Set<AnyCancellable>()

    public func fetch<Item>(request: APIEndPoint, decodingType: Item.Type) where Item: Decodable {
        URLSession.shared
            .dataTaskPublisher(for: request.urlRequest)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: decodingType, decoder: JSONDecoder())
            .sink { result in
            } receiveValue: { [weak self] data in
                switch request {
                case .getMusicOffers:
                    if let data = data as? MusicOffers {
                        self?.musicOffers = data.offers
                    }
                case .getTicketOffers:
                    if let data = data as? TicketOffers {
                        self?.ticketOffers = data.ticketsOffers
                    }
                case .getAllTickets:
                    if let data = data as? AllTickets {
                        self?.allTickets = data.tickets
                    }
                }
            }
            .store(in: &cancellables)
    }

    public var allowedCharacters = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя "

    public func convertToCurrency(from value: Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = "₽"
        currencyFormatter.locale = Locale(identifier: "ru_RU")
        currencyFormatter.maximumFractionDigits = 0
        currencyFormatter.currencyGroupingSeparator = " "
        guard let currency = currencyFormatter.string(from: value as NSNumber) else { return "Error" }
        return currency
    }


    public func convertTimeStamp(from value: String) -> Date? {
        let dateFromatter = DateFormatter()
        dateFromatter.dateFormat = "YYYY-MM-dd'T'HH:mm:SS"
        dateFromatter.timeZone = .current 
        let date = dateFromatter.date(from: value)
        return date
    }

    public func calculateTimeFlight(from: String, to: String) -> String? {
        guard let dateFrom = convertTimeStamp(from: from), let dateTo = convertTimeStamp(from: to) else { return "" }
        let delta = dateFrom.distance(to: dateTo)
        let hours = Int(delta / 3600)
        let minutes = (delta / 60).truncatingRemainder(dividingBy: 60)
        return String(format: "%i:%02.0f", hours, minutes)
    }
}
