//
//  TabBarView.swift
//  EffectiveMobile-testcase
//
//  Created by Тимур Калимуллин on 02.06.2024.
//

import SwiftUI

struct TabBarView: View {

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.basic.black)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.basic.grey5)
    }

    var body: some View {
        TabView {
            ForEach(Tabs.allCases, id: \.self) { tab in
                switch tab {
                case .airTicket:
                    AirTicketsView().environmentObject(AirTicketsViewModel()).tabItem {
                            tabItem(item: tab.item)
                        }
                case .hotel:
                    ProgressView()
                        .tabItem {
                            tabItem(item: tab.item)
                        }
                case .briefly:
                    ProgressView()
                        .tabItem {
                            tabItem(item: tab.item)
                        }
                case .subscriptions:
                    ProgressView()
                        .tabItem {
                            tabItem(item: tab.item)
                        }
                case .profile:
                    ProgressView()
                        .tabItem {
                            tabItem(item: tab.item)
                        }
                }
            }
        }
    }

    @ViewBuilder
    private func tabItem(item: TabItem) -> some View {
        Image(item.imageName).renderingMode(.template)
        Text(item.title)
    }
}

#Preview {
    TabBarView()
}
