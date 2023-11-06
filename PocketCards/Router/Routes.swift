//
//  Routes.swift
//  Unison
//
//  Created by Moroz Pavlo on 2023-06-14.
//

import SwiftUI


class Routes: RoutesObject {
    
    enum CardsRootStack: Hashable {
        case settingsScreen
    }
    
    enum AddCardsRootStack: Hashable {
        
    }
    
    enum SettingsRootStack: Hashable {
        
    }
    
    enum AuthenticationRootStack: Hashable {
        case signByEmail
    }
           
    @Published var isModalOnlyFullScreenCoverAuthenticationViewActive = false
}
