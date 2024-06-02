//
//  AllTicketView.swift
//  EffectiveMobile-testcase
//
//  Created by Тимур Калимуллин on 02.06.2024.
//

import SwiftUI

struct AllTicketView: View {
    let dateFrom: Date
    let dateTo: Date?
    let ticketFrom: String
    let ticketTo: String

    @StateObject var viewModel: AirTicketsViewModel = AirTicketsViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Spacer()
                header
                scrollTickets.scrollContentBackground(.hidden)
            }
            buttons.padding(.bottom)
        }
        .onAppear(perform: {
            viewModel.fetch(request: .getAllTickets, decodingType: AllTickets.self)
        })
        .background(Color.basic.black)
    }

    @ViewBuilder
    var header: some View {
        HStack {
            Button {presentationMode.wrappedValue.dismiss()} label: { Image(systemName: "arrow.backward").padding(.leading, 8) }
            VStack(alignment: .leading, spacing: 4) {
                Text("\(ticketFrom)-\(ticketTo)")
                    .font(.system(size: FontSize.title3, weight: .semibold))
                    .foregroundColor(Color.basic.white)
                HStack(spacing: 4) {
                    if let dateTo = dateTo {
                        Text("\(dateFrom.formatted(.dateTime.day().month().locale(Locale(identifier: "ru_RU"))))-\(dateTo.formatted(.dateTime.day().month().locale(Locale(identifier: "ru_RU")))),")
                            .font(.system(size: FontSize.title4, weight: .semibold))
                            .foregroundColor(Color.basic.grey6)
                    } else {
                        Text("\(dateFrom.formatted(.dateTime.day().month().locale(Locale(identifier: "ru_RU")))),").font(.system(size: FontSize.title4, weight: .semibold))
                            .foregroundColor(Color.basic.grey6)
                    }
                    Text("1 пассажир")
                        .font(.system(size: FontSize.title4, weight: .semibold))
                        .foregroundColor(Color.basic.grey6)
                    
                }
            }.padding(.vertical, 8)
        }.frame(maxWidth: .infinity, maxHeight: 56, alignment: .leading).background(Color.basic.grey2).cornerRadius(8).padding(.horizontal, 16)
            .navigationBarHidden(true)
    }

    @ViewBuilder
    var buttons: some View {
        HStack {
            Button {
            } label: {
                Label("Фильтр", systemImage: "slider.horizontal.3")
                    .font(.system(size: FontSize.title4))
                    .foregroundColor(Color.basic.white)
            }
            Button {
            } label: {
                Label("График цен", image: "chart")
                    .font(.system(size: FontSize.title4))
                    .foregroundColor(Color.basic.white)
            }
        }
        .frame(width: 203, height: 37)
        .background(Color.special.blue)
        .cornerRadius(50)
    }
}

//MARK: Tickets Views
extension AllTicketView {
    @ViewBuilder
    private var scrollTickets: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(viewModel.allTickets, id: \.id) {ticket in 
                    ZStack(alignment: .topLeading) {
                        ticketView(ticket: ticket)
                        badgeView(for: ticket).padding(.leading).offset(y: -8)
                    }
                }
            }.padding(.top, 8)
        }.scrollContentBackground(.hidden)
    }

    @ViewBuilder
    private func timeStamp(value: String) -> some View {
        if let date = viewModel.convertTimeStamp(from: value) {
            Text(date.formatted(Date.FormatStyle()
                .hour(.twoDigits(amPM: .omitted)).minute(.twoDigits).locale(Locale(identifier: "ru_RU"))))
        }

    }

    @ViewBuilder
    private func badgeView(for ticket: AllTickets.Ticket) -> some View {
        if let badge = ticket.badge {
            Text(badge)
                .frame(width: 126, height: 21)
                .font(.system(size: FontSize.title4))
                .foregroundColor(Color.basic.white)
                .background(Color.special.blue)
                .cornerRadius(50)
        }
    }


    @ViewBuilder
    private func ticketView(ticket: AllTickets.Ticket) -> some View {
        VStack {
            VStack(alignment: .leading) {
                Text(viewModel.convertToCurrency(from: ticket.price.value))
                    .font(.system(size: FontSize.title1, weight: .semibold))
                    .foregroundColor(Color.basic.white)
                HStack(alignment: .top) {
                    Circle().fill(Color.special.red).frame(width: 24, height: 24)
                    VStack {
                        timeStamp(value: ticket.departure.date)
                            .font(.system(size: FontSize.title4))
                            .foregroundColor(Color.basic.white)
                        Text(ticket.departure.airport)
                            .font(.system(size: FontSize.title4))
                            .foregroundColor(Color.basic.grey6)
                    }
                    Rectangle()
                        .fill(Color.basic.grey6)
                        .frame(width: 10, height: 1)
                        .padding(.top, 8)
                    VStack {
                        timeStamp(value: ticket.arrival.date)
                            .font(.system(size: FontSize.title4))
                            .foregroundColor(Color.basic.white)
                        Text(ticket.arrival.airport)
                            .font(.system(size: FontSize.title4))
                            .foregroundColor(Color.basic.grey6)
                    }.padding(.trailing, 8)
                    HStack(spacing: 0) {
                        if let deltaHour = viewModel.calculateTimeFlight(from: ticket.departure.date, to: ticket.arrival.date) {
                            Text("\(deltaHour)ч в пути")
                                .font(.system(size: FontSize.title4))
                                .foregroundColor(Color.basic.white)
                        }
                        if !ticket.hasTransfer {
                            Text("/")
                                .font(.system(size: FontSize.title4))
                                .foregroundColor(Color.basic.grey6)
                            Text("Без пересадок")
                                .font(.system(size: FontSize.title4))
                                .foregroundColor(Color.basic.white)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
            }.frame(maxWidth: .infinity, alignment: .leading).padding([.top, .bottom, .leading], 16)
        }.background(Color.basic.grey1).cornerRadius(9).padding(.horizontal, 16)
    }
}

#Preview {
    AllTicketView(dateFrom: .now, dateTo: nil, ticketFrom: "Москва", ticketTo: "Сочи")
}
