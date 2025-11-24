//
//  RegisterView.swift
//  AquaMate
//
//  Created by Andrés Quevedo on 27/10/2025.
//

import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var userName = ""
    var body: some View {
        
        NavigationStack {
            VStack{
                RegisterHeader()
                RegisterForm(email: $email, password: $password, confirmPassword: $confirmPassword, userName: $userName)
                    .padding(.horizontal, 30)
                
                
                AlreadyHaveAnAccount()
                
                
            }
            .padding(.bottom, 40)
        }
    }
        
}



#Preview {
    RegisterView()
}
