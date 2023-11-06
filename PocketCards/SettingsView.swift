//
//  SettingsPage.swift
//  PocketCards
//
//  Created by Moroz Pavlo on 2023-09-12.
//

import SwiftUI

import SwiftUI

struct SettingsPage: View {
        
        @EnvironmentObject private var router: Router
        @EnvironmentObject private var routes: Routes
        @EnvironmentObject var selectedTab: SelectedTab
    
        @StateObject private var viewModel = SettingsViewModel()


        var body: some View {
            List {
                Button("Log out") {
                    Task {
                        do {
                            try viewModel.signOut()
                            selectedTab.tab = 0
                        } catch {
    
                        }
                    }
                }
    
                Button(role: .destructive) {
                    Task {
                        do {
                            try await viewModel.deleteAccount()
                            selectedTab.tab = 0
                        } catch {
    
                        }
                    }
                } label: {
                    Text("Delete account")
                }
    
                if viewModel.authProviders.contains(.email) {
                    emailSection
                }
    
            }
            .navigationBarTitle("Settings")
            .onAppear {
                viewModel.loadAuthProviders()
                viewModel.loadAuthUser()
            }
        }
    }
    
    extension SettingsPage {
        private var emailSection: some View {
            Section {
                Button("Reset Password") {
                    Task {
                        do {
                            try await viewModel.resetPassword()
                        } catch {
    
                        }
                    }
                }
    
                Button("Update Password") {
                    Task {
                        do {
                            try await viewModel.updatePassword()
                            print("DEBUG: Password UPDATED!")
                        } catch {
    
                        }
                    }
                }
    
                Button("Update email") {
                    Task {
                        do {
                            try await viewModel.updateEmail()
                            print("DEBUG: Email UPDATED!")
                        } catch {
    
                        }
                    }
                }
            } header: {
                Text("Email function")
            }
    
        }
    }
    
@MainActor
final class SettingsViewModel: ObservableObject {

    @Published var authProviders: [AuthProviderOption] = []
    @Published var authUser: AuthDataResultModel? = nil

    let authenticationManager: AuthenticationManager
    let signInAppleHelper: SignInWithAppleHelper
    let signInWithGoogleHelper: SignInWithGoogleHelper

    init(authenticationManager: AuthenticationManager, signInAppleHelper: SignInWithAppleHelper, signInWithGoogleHelper: SignInWithGoogleHelper) {
        self.authenticationManager = authenticationManager
        self.signInWithGoogleHelper = signInWithGoogleHelper
        self.signInAppleHelper = signInAppleHelper
    }

    convenience init () {
        self.init(authenticationManager: AuthenticationManager(),
                  signInAppleHelper: SignInWithAppleHelper(),
                  signInWithGoogleHelper: SignInWithGoogleHelper())
    }

    func loadAuthUser() {
        self.authUser = try? authenticationManager.getAuthenticatedUser()
    }

    func loadAuthProviders() {
        if let providers = try? authenticationManager.getProviders() {
            authProviders = providers
        }
    }

    func signOut() throws {
        try authenticationManager.signOut()
    }

    func deleteAccount() async throws {
        try await authenticationManager.delete()
    }

    func resetPassword() async throws {
      let authUser = try authenticationManager.getAuthenticatedUser()

        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }

      try await authenticationManager.resetPassword(email: email)
    }

    func updateEmail() async throws {

        let email = "hello1234@gmail.com"
        try await authenticationManager.updateEmail(email: email)
    }

    func updatePassword() async throws {
        let password = "Hello123!"
        try await authenticationManager.updatePassword(password: password)
    }
}
