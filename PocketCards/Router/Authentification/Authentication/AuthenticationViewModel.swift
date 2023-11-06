//
//  AuthenticationViewModel.swift
//  FirebaseApp
//
//  Created by Moroz Pavlo on 2023-03-22.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    let authenticationManager: AuthenticationManager
    let signInAppleHelper: SignInWithAppleHelper
    let signInWithGoogleHelper: SignInWithGoogleHelper
    let userManager: UserManager
    
    init(authenticationManager: AuthenticationManager,
         signInAppleHelper: SignInWithAppleHelper,
         signInWithGoogleHelper: SignInWithGoogleHelper,
         userManager: UserManager) {
        self.authenticationManager = authenticationManager
        self.signInAppleHelper = signInAppleHelper
        self.signInWithGoogleHelper = signInWithGoogleHelper
        self.userManager = userManager
    }
    
    convenience  init () {
        self.init(authenticationManager: AuthenticationManager(),
                  signInAppleHelper: SignInWithAppleHelper(),
                  signInWithGoogleHelper: SignInWithGoogleHelper(),
                  userManager: UserManager())
    }
    
    func signInGoogle() async throws {
        
        let tokens = try await signInWithGoogleHelper.signIn()
        let authDataResult = try await authenticationManager.signInWithGoogle(tokens: tokens)
        let user = DatabaseUser(auth: authDataResult)
        try await userManager.createNewUserIfNeeded(user: user)
    }
    
    func signInApple() async throws {
        
        let signInAppleResultsTokens = try await signInAppleHelper.startSignInWithAppleFlow()
        let authDataResult =  try await self.authenticationManager.signInWithApple(tokens: signInAppleResultsTokens)
        let user = DatabaseUser(auth: authDataResult)
        try await userManager.createNewUserIfNeeded(user: user)
    }

}



