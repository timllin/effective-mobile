//
//  DetailedSearchView.swift
//  EffectiveMobile-testcase
//
//  Created by Тимур Калимуллин on 01.06.2024.
//

import SwiftUI


struct DetailedSearchView: View {
    @Binding var ticketFrom: String
    @Binding var ticketTo: String

    @State private var dateFrom: Date = Date.now
    @State private var dateTo: Date = Date.now
    @State private var dateToSet: Bool = false

    @StateObject var viewModel = AirTicketsViewModel()
    @Environment(\.presentationMode) var presentationMode

    @State private var subscribeTo = false

    var body: some View {
        NavigationStack {
            VStack {
                searchView
                setupTicketSearch
                ticketOffers

                NavigationLink(destination: AllTicketView(dateFrom: dateFrom, dateTo: dateToSet ? dateTo : nil, ticketFrom: ticketFrom, ticketTo: ticketTo, viewModel: viewModel), label: {
                    Text("Посмотреть все билеты") 
                        .frame(maxWidth: .infinity, maxHeight: 42)
                        .foregroundColor(Color.basic.white)
                        .background(Color.special.blue)
                        .cornerRadius(8)
                        .padding(.horizontal, 16)
                })

                HStack {
                    Label {
                        Text("Подписка на цену")

                            .font(.system(size: FontSize.text1))
                            .foregroundColor(Color.basic.white)
                    } icon : {
                        Image(systemName: "bell.fill")
                            .font(.system(size: FontSize.text1))
                            .foregroundColor(Color.special.blue)
                    }.frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 16)
                    Spacer()
                    Toggle("", isOn: $subscribeTo).padding(.trailing, 16).frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                }
                .frame(maxWidth: .infinity, maxHeight: 51)
                .background(Color.basic.grey2)
                .cornerRadius(8)
                .padding(.horizontal, 16).padding(.top, 24)
            }
            .navigationBarHidden(true)
            .frame(maxHeight: .infinity, alignment: .top)
            .background(Color.basic.black)
            .onAppear(perform: {
                viewModel.fetch(request: .getTicketOffers, decodingType: TicketOffers.self)
            })
        }
    }
}

//MARK: Search
extension DetailedSearchView {
    @ViewBuilder
    var searchView: some View {
        HStack {
            Button { presentationMode.wrappedValue.dismiss() } label: { Image(systemName: "arrow.backward").frame(width: 24, height: 24).foregroundColor(Color.basic.white)}
            VStack {
                HStack {
                    TextField("", text: $ticketFrom, prompt: Text("Откуда - Москва")
                        .foregroundColor(Color.basic.grey6))
                    .font(.system(size: FontSize.buttonText, weight: .semibold))
                    .foregroundColor(Color.basic.white)
                    Button {
                        swap(&ticketFrom, &ticketTo)
                    } label : {
                        Image(systemName: "arrow.up.arrow.down").resizable().frame(width: 12, height: 12).foregroundColor(Color.basic.white)
                    }.padding(.trailing, 24)
                }
                Divider().background(Color.basic.grey6).padding(.trailing, 16)
                HStack {
                    TextField("", text: $ticketTo, prompt: Text("Куда - Турция")
                        .foregroundColor(Color.basic.grey6))
                    .font(.system(size: FontSize.buttonText, weight: .semibold))
                    .foregroundColor(Color.basic.white)
                    Button {
                        ticketTo.removeAll()
                    } label : {
                        Image(systemName: "xmark").resizable().frame(width: 9, height: 9).foregroundColor(Color.basic.grey7)
                    }.padding(.trailing, 24)
                }
            }
        }
        .frame(height: 96)
        .background(Color.basic.grey3)
        .cornerRadius(16)
        .padding(.horizontal, 16)
    }
}

//MARK: Settings
extension DetailedSearchView {
    @ViewBuilder
    private func datePlaceHolder(date: Date) -> some View {
        HStack(spacing: 0) {
            Text(date.formatted(.dateTime.day().month().locale(Locale(identifier: "ru_RU"))))
                .font(.system(size: FontSize.title4))
                .foregroundColor(Color.basic.white)
            Text(", \(date.formatted(.dateTime.weekday(.short).locale(Locale(identifier: "ru_RU"))).lowercased())")
                .font(.system(size: FontSize.title4))
                .foregroundColor(Color.basic.grey6)
        }
    }

    @ViewBuilder
    var setupTicketSearch: some View {
        ScrollView(.horizontal) {
            HStack {
                DatePicker("", selection: $dateTo, in: dateFrom..., displayedComponents: .date)
                    .frame(width: 88, height: 33)
                    .labelsHidden()
                    .opacity(0.1)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .onChange(of: dateTo, perform: { _ in
                        dateToSet = true
                    })
                    .overlay(content: {
                        returnTicketView
                            .frame(width: 105, height: 33)
                            .font(.system(size: FontSize.title4))
                            .foregroundColor(Color.basic.white)
                            .background(Color.basic.grey3)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .allowsHitTesting(false)
                    })
                    .padding(.trailing, 8)

                DatePicker("", selection: $dateFrom, in: Date.now..., displayedComponents: .date)
                    .frame(width: 105, height: 33)
                    .labelsHidden()

                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .onSubmit {
                        dateToSet = true
                    }
                    .overlay(content: {
                        datePlaceHolder(date: dateFrom)
                            .frame(width: 105, height: 33)
                            .background(Color.basic.grey3)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .allowsHitTesting(false)
                    })

                Label("1,эконом", systemImage: "person.fill")
                    .frame(width: 105, height: 33)
                    .font(.system(size: FontSize.title4))
                    .foregroundColor(Color.basic.white)
                    .background(Color.basic.grey3)
                    .clipShape(RoundedRectangle(cornerRadius: 50))

                Label("Фильтры", systemImage: "slider.horizontal.3")
                    .frame(width: 105, height: 33)
                    .font(.system(size: FontSize.title4))
                    .foregroundColor(Color.basic.white)
                    .background(Color.basic.grey3)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
            }.padding(.horizontal)
        }
        .scrollIndicators(.hidden)
        .padding([.horizontal, .top], 16)
    }
    
    @ViewBuilder
    private var returnTicketView: some View {
        if dateToSet {
            datePlaceHolder(date: dateTo)
        } else {
            Label("Обратно", systemImage: "plus")
        }
    }
}

//MARK: Ticket Offers
extension DetailedSearchView {
    var ticketOffers: some View {
        VStack {
            Text("Прямые рейсы")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: FontSize.title2, weight: .semibold))
                .foregroundColor(Color.basic.white)
                .padding([.top, .leading], 16)
            ForEach(Array(zip(viewModel.ticketOffers.prefix(3).indices, viewModel.ticketOffers.prefix(3))), id: \.0) { index, ticket in

                
                HStack(alignment: .top) {
                    Circle().fill(getColorCompany(index)).frame(width: 24, height: 24)
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(ticket.title)
                                .font(.system(size: FontSize.title4))
                                .foregroundColor(Color.basic.white)
                            Spacer()
                            HStack(spacing: 0) {
                                Text(viewModel.convertToCurrency(from: ticket.price.value)).font(.system(size: FontSize.text2))
                                    .foregroundColor(Color.special.darkBlue)
                                Image(systemName: "chevron.right").font(.system(size: FontSize.text2))
                                    .foregroundColor(Color.special.darkBlue)
                            }
                        }
                        Text(ticket.timeRange.joined(separator: " "))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: FontSize.text2))
                            .foregroundColor(Color.basic.white)
                            .lineLimit(1)
                    }
                }.frame(maxWidth: .infinity, alignment: .topLeading).padding(.horizontal, 16).padding(.bottom, 8)
                Divider().background((index == 2) ? Color.basic.grey1 : Color.basic.grey6).padding(.horizontal, 16).padding(.bottom, 8)
            }
        }.background(Color.basic.grey1).cornerRadius(16).padding(15)
    }

    func getColorCompany(_ index: Int) -> Color {
        if index == 0 {
            return Color.special.red
        } else if index == 1 {
            return Color.special.blue
        } else {
            return Color.basic.white
        }
    }
}

#Preview {
    DetailedSearchView(ticketFrom: .constant(""), ticketTo: .constant(""))
}
