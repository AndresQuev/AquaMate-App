//
//  AuthViewModel.swift
//  AquaMate
//
//  Created by Andrés Quevedo on 27/10/2025.
//

import SwiftUI

struct AuthViewModel: View {
    // Estado: qué tab está activo
    @State private var isLogin: Bool = true
    
    // Campos Login
    @State private var loginEmail: String = ""
    @State private var loginPassword: String = ""
    
    // Campos Register
    @State private var registerEmail: String = ""
    @State private var registerPassword: String = ""
    @State private var registerConfirmPassword: String = ""
    @State private var registerUserName: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                AquaUI.background
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // Header similar al HomeTopHeader pero para Auth
                        AuthHeader()
                        
                        // Segmented "Login / Register" similar al de Home
                        AuthSegmentedControl(isLogin: $isLogin)
                        
                        // Card blanco con el formulario
                        VStack(spacing: 20) {
                            if isLogin {
                                LoginForm(
                                    userEmail: $loginEmail,
                                    userPassword: $loginPassword
                                )
                            } else {
                                RegisterForm(
                                    email: $registerEmail,
                                    password: $registerPassword,
                                    confirmPassword: $registerConfirmPassword,
                                    userName: $registerUserName
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.95))
                        .cornerRadius(24)
                        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
                        
                        // Textito abajo para cambiar entre Login/Register
                        AuthFooter(isLogin: $isLogin)
                        
                        // Tip al estilo Aqua
                        TipCard()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 32)
                }
            }
        }
    }
}

// MARK: - Header (similar al de Home)

struct AuthHeader: View {
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AquaUI.blue, AquaUI.lightBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Image("AquaMateLogo")
                    .resizable()
                    .scaledToFit()
                    .padding(8)
            }
            .frame(width: 70, height: 70)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Aqua Mate")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(AquaUI.primaryGreen)
                
                Text("Don’t let your plants dry out")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))
                
                Text("Welcome back 👋")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
    }
}

// MARK: - Segmented Login / Register

struct AuthSegmentedControl: View {
    @Binding var isLogin: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isLogin = true
                }
            } label: {
                Text("Log In")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .foregroundColor(isLogin ? .black : .white)
                    .background(
                        Group {
                            if isLogin {
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(AquaUI.secondaryGreen)
                            } else {
                                Color.clear
                            }
                        }
                    )
            }
            .buttonStyle(.plain)
            
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isLogin = false
                }
            } label: {
                Text("Register")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .foregroundColor(!isLogin ? .black : .white)
                    .background(
                        Group {
                            if !isLogin {
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(AquaUI.secondaryGreen)
                            } else {
                                Color.clear
                            }
                        }
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(4)
        .background(
            Capsule()
                .fill(AquaUI.primaryGreen)
        )
    }
}

// MARK: - Login Form (adaptado al estilo Home/SearchBar)

struct LoginForm: View {
    @Binding var userEmail: String
    @Binding var userPassword: String
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Email
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
            
            // Password
            HStack(spacing: 10) {
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
                SecureField("Password", text: $userPassword)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.9))
            .cornerRadius(14)
            
            // Botón Log In
            Button {
                print("Log In button tapped.")
            } label: {
                Text("Log In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(AquaUI.blue)
                    .cornerRadius(14)
            }
            .padding(.top, 4)
            
            // Texto "or login with"
            Text("or login with")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.6))
                .padding(.top, 4)
            
            // Botones sociales
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

// MARK: - Register Form (mismo estilo que Login form)

struct RegisterForm: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var userName: String
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Email
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
            
            // Password
            HStack(spacing: 10) {
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
                SecureField("Password", text: $password)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.9))
            .cornerRadius(14)
            
            // Confirm Password
            HStack(spacing: 10) {
                Image(systemName: "lock.badge.checkmark.fill")
                    .foregroundColor(.gray)
                SecureField("Confirm password", text: $confirmPassword)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.9))
            .cornerRadius(14)
            
            // User Name
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
                print("Register button tapped.")
            } label: {
                Text("Register")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(AquaUI.blue)
                    .cornerRadius(14)
            }
            .padding(.top, 4)
        }
    }
}

// MARK: - Footer: cambiar entre Login/Register (sin NavigationLink)

struct AuthFooter: View {
    @Binding var isLogin: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            if isLogin {
                Text("Don't have an account?")
                    .foregroundColor(.black.opacity(0.7))
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        isLogin = false
                    }
                } label: {
                    Text("Create here")
                        .bold()
                        .foregroundColor(AquaUI.primaryGreen)
                }
                .buttonStyle(.plain)
            } else {
                Text("Already have an account?")
                    .foregroundColor(.black.opacity(0.7))
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        isLogin = true
                    }
                } label: {
                    Text("Log in here")
                        .bold()
                        .foregroundColor(AquaUI.primaryGreen)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Tip Card (estilo más parecido al Home)

struct TipCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Did you know?")
                .font(.headline)
                .foregroundColor(.orange)
            
            Text("Keeping a regular watering schedule helps your plants grow healthier and stronger.")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.7))
        }
        .padding(16)
        .background(AquaUI.softYellow)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Preview

#Preview {
    AuthViewModel()
}
