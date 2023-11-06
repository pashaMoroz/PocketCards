//
//  SignInEmailViewModel.swift
//  FirebaseApp
//
//  Created by Moroz Pavlo on 2023-03-16.
//

import Foundation

enum AuthenticationError: Error {
    case badCredentials
}

@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    let authenticationManager: AuthenticationManager
    let userManager: UserManager
    
    init(authenticationManager: AuthenticationManager, userManager: UserManager) {
        self.authenticationManager = authenticationManager
        self.userManager = userManager
    }
    
    convenience init () {
        self.init(authenticationManager: AuthenticationManager(), userManager: UserManager())
    }
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else { throw AuthenticationError.badCredentials }
        
        let authDataResult = try await authenticationManager.createUser(email: email, password: password)
        let user = DatabaseUser(auth: authDataResult)
        try await userManager.createNewUserIfNeeded(user: user)    }
    
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else { throw AuthenticationError.badCredentials }
        
        try await authenticationManager.signInUser(email: email, password: password)
    }
}
