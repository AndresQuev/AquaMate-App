//
//  RegisterForm.swift
//  AquaMate
//
//  Created by Andrés Quevedo on 15/12/2025.
//

import SwiftUI

struct RegisterForm: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var userName: String
    
    var isLoading: Bool
    var errorMessage: String?
    var onRegister: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Campo Email
            HStack(spacing: 10) {
                Image(systemName: "envelope.fill")
                    .foregroundColor(.gray)
                TextField("Email", text: $email)
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
                SecureField("Password", text: $password)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.9))
            .cornerRadius(14)
            
            // Campo Confirmar Contraseña
            HStack(spacing: 10) {
                Image(systemName: "lock.badge.checkmark.fill")
                    .foregroundColor(.gray)
                SecureField("Confirm password", text: $confirmPassword)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.9))
            .cornerRadius(14)
            
            // Campo Nombre de Usuario
            HStack(spacing: 10) {
                Image(systemName: "person.fill")
                    .foregroundColor(.gray)
                TextField("User name", text: $userName)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.9))
            .cornerRadius(14)
            
            // Botón Register
            Button {
                onRegister()
            } label: {
                HStack {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Register")
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
        }
    }
}

