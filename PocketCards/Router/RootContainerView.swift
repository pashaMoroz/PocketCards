//
//  ContentView.swift
//  Unison
//
//  Created by Moroz Pavlo on 2023-06-09.
//

import SwiftUI


class SelectedTab: ObservableObject {
    @Published var tab: Int = 0
}

struct RootContainerView: View {
    
    @StateObject private var routes = Routes()
    @EnvironmentObject private var router: Router
    
    @StateObject private var selectedTab = SelectedTab()
    @State var isStated = false
    @State var circleProgress: CGFloat = 1.0
    
    let icons = [
        "doc",
        "plus",
        "gearshape",
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            
            //Content
            ZStack {
                switch selectedTab.tab {
                case 0 :
                    cardPage
                case 1 :
                    addCardPage
                case 2 :
                    settingsPage
                default:
                    EmptyView()
                }
            }
            
            Divider()
                .padding(.bottom, 10)
            HStack {
                ForEach(0..<3, id: \.self) { number in
                    Spacer()
                    Button {
                        if number == 1 {
                            //plus sheet
                        } else {
                            selectedTab.tab = number
                        }
                    } label: {
                        if number == 1 {
                            Image(systemName: selectedTab.tab == number ? "\(icons[number])" + ".fill" : icons[number] )
                                .font(.system(size: 25,
                                              weight: .regular,
                                              design: .default))
                                .foregroundColor(Color.white)
                                .frame(width: 60, height: 60)
                                .background(Color.red)
                                .cornerRadius(30)
                            
                        }
                        else {
                            Image(systemName: selectedTab.tab == number ? "\(icons[number])" + ".fill" : icons[number] )
                                .font(.system(size: 25,
                                              weight: .regular,
                                              design: .default))
                                .foregroundColor(selectedTab.tab == number ? Color.brown : Color.gray)
                            
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
    var cardPage: some View {
        CardPage()
            .rootNavigationStack(for: Routes.CardsRootStack.self) { destination in
                switch destination {
                case .settingsScreen:
                    SettingsPage()
                        .environmentObject(selectedTab)
                }
            }
            .environmentObject(routes)
    }
    
    var addCardPage: some View {
        AddCardPage()
            .rootNavigationStack(for: Routes.AddCardsRootStack.self) { destination in
                switch destination {
                default:
                    EmptyView()
                }
            }
            .environmentObject(routes)
    }
    
    var settingsPage: some View {
        SettingsPage()
            .rootNavigationStack(for: Routes.SettingsRootStack.self) { destination in
                switch destination {
                default:
                    EmptyView()
                }
            }
            .environmentObject(routes)
    }
    
}

struct RootContainerView_Previews: PreviewProvider {
    static var previews: some View {
        RootContainerView()
    }
}
