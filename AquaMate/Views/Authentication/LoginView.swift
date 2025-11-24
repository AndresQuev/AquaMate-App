//
//  LoginView.swift
//  AquaMate
//
//  Created by Andrés Quevedo on 27/10/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var userEmail = ""
    @State private var userPassword = ""
    
    var body: some View {
        NavigationStack {
            VStack { // <-- Agregado un VStack para control de layout
                Spacer() // Empuja el contenido hacia el centro/arriba
                
                LoginHeader()
                
                LoginForm(userEmail: $userEmail, userPassword: $userPassword)
                    .padding(.horizontal, 30) // Margen para los campos de texto
                
                Spacer() // Empuja el contenido hacia el centro/abajo
                
                CreateAccount()
            }
            .padding(.bottom, 40) // Espacio al final
        }
        // Recomendado: Agrega un color de fondo para toda la vista
        .background(Color(.systemGray6).opacity(0.4).ignoresSafeArea())
    }
}





#Preview {
    LoginView()
}
