//
//  AuthenticationView.swift
//  FirebaseApp
//
//  Created by Moroz Pavlo on 2023-03-16.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

struct AuthenticationView: View {
    
    @StateObject var viewModel = AuthenticationViewModel()
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var routes: Routes
    
    var body: some View {
        VStack {
            VStack {
                emailButtonView
                googleButtonView
                appleButtonView
            }
        }
        .padding()
        .navigationTitle("Sign In")
    }
        
    var emailButtonView: some View  {
        Button {
            router.push(Routes.AuthenticationRootStack.signByEmail)
        } label: {
            Text("Sign In With Email")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
    
    var googleButtonView: some View {
        
        GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .pressed)) {
            Task {
                do {
                    try await viewModel.signInGoogle()
                    await router.pop($routes.isModalOnlyFullScreenCoverAuthenticationViewActive)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    var appleButtonView: some View {
        Button {
            Task {
                do {
                    try await viewModel.signInApple()
                    await router.pop($routes.isModalOnlyFullScreenCoverAuthenticationViewActive)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        } label: {
            SignInWitnAppleButtonViewRepresentable(type: .signIn, style: .black)
            .allowsHitTesting(false)
        }
        .frame(height: 55)
    }
}


struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView()
                .environmentObject(Routes())
                .environmentObject(Router())
        }
    }
}
