//
//  AirTicketsView.swift
//  EffectiveMobile-testcase
//
//  Created by Тимур Калимуллин on 31.05.2024.
//

import SwiftUI
import Combine

struct AirTicketsView: View {
    @AppStorage("ticketFrom") var ticketFrom: String = ""
    @State var ticketTo: String = ""
    @State var isShowingSearch: Bool = false
    @State var isDestinationSelected: Bool = false

    @EnvironmentObject var viewModel: AirTicketsViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Text("Поиск дешевых\nавиабилетов")
                    .frame(height: 62)
                    .font(.system(size: FontSize.title1, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.basic.white)
                    .padding(.top, 26)

                searchView

                Text("Музыкально отлететь")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .font(.system(size: FontSize.title1, weight: .semibold))
                    .foregroundStyle(Color.basic.white)
                    .padding(.top, 32)
                    .padding(.leading, 16)

                musicTickets
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity, alignment: .top)
            .background(Color.basic.black)
            .onAppear(perform: {
                viewModel.fetch(request: .getMusicOffers, decodingType: MusicOffers.self)
            })
            .navigationDestination(isPresented: $isDestinationSelected, destination: {
                DetailedSearchView(ticketFrom: $ticketFrom, ticketTo: $ticketTo)
            })
            .sheet(isPresented: $isShowingSearch, content: {
                SearchView(isShowingSearch: $isShowingSearch, isDestinationSelected: $isDestinationSelected, ticketFrom: $ticketFrom, ticketTo: $ticketTo)
                    .presentationDragIndicator(.visible)
            })
        }
    }
}

//MARK: Search Bar
extension AirTicketsView {
    var searchView: some View {
        VStack {
            HStack {
                Image("search")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.leading, 8)
                    .padding(.trailing, 12)
                    .foregroundColor(Color.basic.white)
                VStack(alignment: .leading) {
                    TextField("", text: $ticketFrom, prompt: Text("Откуда - Москва").foregroundColor(Color.basic.grey6))
                        .font(.system(size: FontSize.buttonText, weight: .semibold))
                        .foregroundColor(Color.basic.white)
                        .onReceive(Just(ticketFrom), perform: { newValue in
                            let filtered = newValue.filter { viewModel.allowedCharacters.contains($0.lowercased())}
                            if filtered != newValue {
                                ticketFrom = filtered
                            }
                        })

                    Divider().background(Color.basic.grey6).padding(.trailing, 16)
                    TextField("", text: $ticketTo, prompt: Text("Куда - Турция").foregroundColor(Color.basic.grey6))
                        .font(.system(size: FontSize.buttonText, weight: .semibold))
                        .foregroundColor(Color.basic.white)
                        .onTapGesture {
                            isShowingSearch.toggle()
                        }
                        .onReceive(Just(ticketTo), perform: { newValue in
                            let filtered = newValue.filter { viewModel.allowedCharacters.contains($0.lowercased())}
                            if filtered != newValue {
                                ticketTo = filtered
                            }
                        })
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
            .background(Color.basic.grey4)
            .cornerRadius(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.basic.grey4)
                    .shadow(color: Color.basic.black, radius: 1, x: 0, y: 4)
                    .blur(radius: 4, opaque: false))
            .padding(16)
        }
        .frame(height: 122)
        .background(Color.basic.grey3)
        .cornerRadius(16)
        .padding(.top, 38)
        .padding(.horizontal, 16)

    }
}

//MARK: Music Tickets Recomendation
extension AirTicketsView {
    @ViewBuilder
    var musicTickets: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 67) {
                ForEach(viewModel.musicOffers, id: \.id) {musicOffer in
                    VStack(alignment: .leading, spacing: 8) {
                        Image("\(musicOffer.id)").resizable()
                            .frame(width: 132, height: 133)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        Text(musicOffer.title)
                            .font(.system(size: FontSize.title3, weight: .semibold))
                            .foregroundStyle(Color.basic.white)
                        Text(musicOffer.town)
                            .font(.system(size: FontSize.text2, weight: .semibold))
                            .foregroundStyle(Color.basic.white)
                        Label(
                            title: { Text("от \(viewModel.convertToCurrency(from: musicOffer.price.value))").foregroundStyle(Color.basic.white)
                                .font(.system(size: FontSize.text2, weight: .semibold)) },
                            icon: { Image("airplane")
                                    .resizable()
                                    .frame(width: 17, height: 17)
                            }
                        )
                    }
                }
            }
            .frame(height: 213)
            .padding(.leading, 16)
        }
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    AirTicketsView().environmentObject(AirTicketsViewModel())
}
