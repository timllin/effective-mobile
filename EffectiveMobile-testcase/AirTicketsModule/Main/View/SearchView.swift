//
//  SearchView.swift
//  EffectiveMobile-testcase
//
//  Created by Тимур Калимуллин on 01.06.2024.
//

import SwiftUI

struct SearchView: View {
    @Binding var isShowingSearch: Bool
    @Binding var isDestinationSelected: Bool
    @Binding var ticketFrom: String
    @Binding var ticketTo: String 
    var body: some View {
        NavigationStack {
            VStack {
                searchView.padding(.top, 8)
                searchHelpView
                destintationSuggestionView
            }
            .background(Color.basic.grey2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    var searchView: some View {
        VStack {
            HStack {
                Image("airplaneOff")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .scaledToFill()
                    .padding(.leading, 16)
                TextField("", text: $ticketFrom, prompt: Text("Откуда - Москва")
                    .foregroundColor(Color.basic.grey6))
                .font(.system(size: FontSize.buttonText, weight: .semibold))
                .foregroundColor(Color.basic.white)
                .onSubmit() {
                    if ticketFrom.count > 0 && ticketTo.count > 0 { endSearch() }
                }
            }
            Divider().background(Color.basic.grey6).padding(.trailing, 16)
            HStack {
                Image("search")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.leading, 16)
                    .foregroundColor(Color.basic.white)
                TextField("", text: $ticketTo, prompt: Text("Куда - Турция")
                    .foregroundColor(Color.basic.grey6))
                .font(.system(size: FontSize.buttonText, weight: .semibold))
                .foregroundColor(Color.basic.white)
                .onSubmit() {
                    if ticketTo.count > 0 { endSearch() }
                }
                Button {
                    ticketTo.removeAll()
                } label : {
                    Image(systemName: "xmark").resizable().frame(width: 9, height: 9).foregroundColor(Color.basic.grey6)
                }.padding(.trailing, 24)
            }
        }
        .frame(height: 96)
        .background(Color.basic.grey3)
        .cornerRadius(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.basic.grey3)
                .shadow(color: Color.basic.black, radius: 1, x: 0, y: 4)
                .blur(radius: 4, opaque: false))
        .padding(16)
    }

    public func endSearch() {
        isShowingSearch.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isDestinationSelected = true
        }
    }
}

//MARK: Search Help Button
extension SearchView {
    enum SearchHelpButton: String, CaseIterable {
        case difficultRoute = "Сложный маршрут"
        case anywhere = "Куда угодно"
        case weekends = "Выходные"
        case hotTickets = "Горячие билеты"

        var buttonAttribute: (String, Color) {
            switch self {
            case .difficultRoute: return ("command", Color.special.darkGreen)
            case .anywhere: return ("globe", Color.special.blue)
            case .weekends: return ("calendar", Color.special.darkBlue)
            case .hotTickets: return ("flame.fill", Color.special.red)
            }
        }
    }

    @ViewBuilder
    func searchHelpButton(_ type: SearchHelpButton) -> some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 8).fill(type.buttonAttribute.1)
                Image(systemName: type.buttonAttribute.0).foregroundColor(Color.basic.white)
            }
            .frame(width: 48, height: 48)
            Text(type.rawValue).font(.system(size: FontSize.text2))
                .foregroundColor(Color.basic.white)
                .multilineTextAlignment(.center)
        }.frame(width: 79, height: 90, alignment: .top)
    }

    @ViewBuilder
    var searchHelpView: some View {
        HStack(spacing: 16) {
            ForEach(SearchHelpButton.allCases, id: \.rawValue) {type in
                switch type {
                case .difficultRoute, .hotTickets, .weekends:
                    NavigationLink(destination: ProgressView()) {
                        searchHelpButton(type)
                    }
                case .anywhere:
                    searchHelpButton(type).onTapGesture {
                        ticketTo = type.rawValue
                        endSearch()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 90)
        .padding(16)
    }
}

//MARK: Search Suggestion
extension SearchView {
    @ViewBuilder
    var destintationSuggestionView: some View {
        let citis: [String] = ["Стамбул", "Сочи", "Пхукет"]
        List {
            ForEach(citis, id: \.self) { city in
                VStack {
                    HStack {
                        Image(city)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.trailing, 8)
                        VStack(alignment: .leading) {
                            Text(city)
                                .font(.system(size: FontSize.title2, weight: .semibold))
                                .foregroundColor(Color.basic.white)
                            Text("Популярное направление")
                                .font(.system(size: FontSize.text2))
                                .foregroundColor(Color.basic.grey5)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    Divider().background(Color.basic.grey6)
                }
                .onTapGesture {
                    ticketTo = city
                    endSearch()
                }

            }
            .listStyle(.plain)
            .listRowBackground(Color.basic.grey3)
            .listRowSeparator(.hidden)
        }
        .offset(x: 0, y: -30)
        .scrollBounceBehavior(.basedOnSize)
        .scrollContentBackground(.hidden)
        
        
    }
}

#Preview {
    SearchView(isShowingSearch: .constant(true), isDestinationSelected: .constant(false), ticketFrom: .constant(""), ticketTo: .constant(""))
}
