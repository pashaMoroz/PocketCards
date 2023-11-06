//
//  ContentView.swift
//  PocketCards
//
//  Created by Moroz Pavlo on 2023-09-12.
//

import SwiftUI

struct CardModel {
    let name: String
}

class CardManager {
    static var languagesCards: [CardModel] = [
        CardModel(name: "Tree"),
        CardModel(name: "Bob"),
        //        CardModel(name: "Salmon"),
        //        CardModel(name: "Tree"),
        //        CardModel(name: "Bob"),
        //        CardModel(name: "Salmon"),
        //        CardModel(name: "Tree"),
        //        CardModel(name: "Bob"),
        //        CardModel(name: "Salmon"),
        //        CardModel(name: "Tree"),
        //        CardModel(name: "Bob"),
        //        CardModel(name: "Salmon"),
        //        CardModel(name: "Tree"),
        //        CardModel(name: "Bob"),
        //        CardModel(name: "Salmon")
    ].reversed()
    
}

struct CardPage: View {
    
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var routes: Routes
    @StateObject private var viewModel: CardPageViewModel = CardPageViewModel()
    private var languagesCards = CardManager.languagesCards
    
    var body: some View {
        VStack(spacing: 40) {
            ZStack {
                Text("No cards")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .bold()
                ForEach(0..<languagesCards.count, id: \.self) { index in
                    CardView(card: languagesCards[index])
                        .rotationEffect(.degrees(Double.random(in: -1...1)))
                        .offset(x: 1, y: CGFloat(index) * 0.5) // Расстояние между карточками
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "gear")
                    .font(.headline)
                    .onTapGesture {
                        router.push(Routes.CardsRootStack.settingsScreen)
                    }
            }
        }
        .onAppear {
            if viewModel.checkAuthentication() == false {
                router.push($routes.isModalOnlyFullScreenCoverAuthenticationViewActive)
            } else {
                Task {
                    try? await viewModel.loadCurrentUser()
                }
            }
        }
        .fullScreenCover(isActive: $routes.isModalOnlyFullScreenCoverAuthenticationViewActive) {
            print("DEBUG: AuthenticationView onDismiss")
            Task {
                try? await viewModel.loadCurrentUser()
            }
        } content: {
            AuthenticationView()
                .rootNavigationStack(for: Routes.AuthenticationRootStack.self) { destination in
                    switch destination {
                        
                    case .signByEmail:
                        SignInEmailView()
                    }
                }
        }
    }
}


@MainActor
final class CardPageViewModel: ObservableObject {
    
    @Published private(set) var user: DatabaseUser? = nil
    @Published var isAuthenticationSuccess: Bool = false
    
    
    let authenticationManager: AuthenticationManager
    let userManager: UserManager
    
    init(authenticationManager: AuthenticationManager, userManager: UserManager) {
        self.authenticationManager = authenticationManager
        self.userManager = userManager
    }
    
    convenience init () {
        self.init(authenticationManager: AuthenticationManager(), userManager: UserManager())
    }
    
    func loadCurrentUser() async throws {
        let authDataResults = try authenticationManager.getAuthenticatedUser()
        self.user = try await userManager.getUser(userId: authDataResults.uid)
    }
    
    func checkAuthentication() -> Bool {
        let authUser = try? authenticationManager.getAuthenticatedUser()
        self.isAuthenticationSuccess = authUser == nil ? false : true
        return authUser == nil ? false : true
    }
}
