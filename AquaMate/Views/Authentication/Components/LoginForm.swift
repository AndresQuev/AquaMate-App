//
//  LoginForm.swift
//  AquaMate
//
//  Created by Andrés Quevedo on 15/12/2025.
//

import SwiftUI

struct LoginForm: View {
    @Binding var userEmail: String
    @Binding var userPassword: String
    
    var isLoading: Bool
    var errorMessage: String?
    var onLogin: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Campo Email
            HStack(spacing: 10) {
                Image(systemName: "envelope.fill")
                    .foregroundColor(.gray)
                TextField("Email address", text: $userEmail)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textInputAutocapitalization(.never)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.9))
            .cornerRadius(14)
            
            // Campo Contraseña
            HStack(spacing: 10) {
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
                SecureField("Password", text: $userPassword)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.9))
            .cornerRadius(14)
            
            // Botón Login
            Button {
                onLogin()
            } label: {
                HStack {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Log In")
                            .font(.headline)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(AquaUI.blue)
                .foregroundColor(.white)
                .cornerRadius(14)
            }
            .disabled(isLoading)
            .padding(.top, 4)
            
            // Mensaje de Error
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Text("or login with")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.6))
                .padding(.top, 4)
            
            // Opciones de Login Social
            HStack(spacing: 12) {
                Button {
                    // Google action
                } label: {
                    HStack {
                        Image("GoogleIcon")
                            .resizable()
                            .frame(width: 18, height: 18)
                        
                        Text("Google")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
                
                Button {
                    // Apple action
                } label: {
                    HStack {
                        Image(systemName: "apple.logo")
                            .font(.system(size: 18, weight: .bold))
                        Text("Apple")
                            .font(.subheadline.weight(.semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(14)
                }
            }
        }
    }
}
