//
//  SignInEmailView.swift
//  FirebaseApp
//
//  Created by Moroz Pavlo on 2023-03-16.
//

import SwiftUI

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var routes: Routes
    
    
    init() {
        print("DEBUG: SignInEmailView ")
    }
    
    
    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            VStack {
                Button {
                    Task {
                        do {
                           try await viewModel.signUp()
                            await router.pop($routes.isModalOnlyFullScreenCoverAuthenticationViewActive)
                        } catch let error {
                            print(error.localizedDescription)
                            //alert
                        }
                    }
                    
                    
                } label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button {
                    Task {
                        do {
                           try await viewModel.signIn()
                            await router.pop($routes.isModalOnlyFullScreenCoverAuthenticationViewActive)
                        } catch let error {
                            print(error.localizedDescription)
                            //alert
                        }
                    }
                    
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            
        }
        .padding()
        .navigationTitle("Sign In with Email")
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInEmailView()
            .environmentObject(Routes())
            .environmentObject(Router())
    }
}
