import SwiftUI

struct AuthViewModel: View {
    
    // Tabs
    @State private var isLogin: Bool = true
    
    // Campos Login
    @State private var loginEmail: String = ""
    @State private var loginPassword: String = ""
    
    // Campos Register
    @State private var registerEmail: String = ""
    @State private var registerPassword: String = ""
    @State private var registerConfirmPassword: String = ""
    @State private var registerUserName: String = ""
    
    // Estado de autenticación
    @State private var isAuthenticated: Bool = false
    @State private var isLoading: Bool = false
    @State private var authError: String? = nil
    
    // 💾 Credenciales demo para el login directo
    private let demoEmail = "user@aquamate.com"
    private let demoPassword = "123456"
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo
                AquaUI.background
                    .ignoresSafeArea()
                
                // Contenido principal
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        AuthHeader()
                        
                        AuthSegmentedControl(isLogin: $isLogin)
                        
                        VStack(spacing: 20) {
                            if isLogin {
                                LoginForm(
                                    userEmail: $loginEmail,
                                    userPassword: $loginPassword,
                                    isLoading: isLoading,
                                    errorMessage: authError,
                                    onLogin: handleLogin
                                )
                            } else {
                                RegisterForm(
                                    email: $registerEmail,
                                    password: $registerPassword,
                                    confirmPassword: $registerConfirmPassword,
                                    userName: $registerUserName,
                                    isLoading: isLoading,
                                    errorMessage: authError,
                                    onRegister: handleRegister
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.95))
                        .cornerRadius(24)
                        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
                        
                        TipCard()
                        
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 32)
                }
                
                // Overlay de loader global
                if isLoading {
                    Color.black.opacity(0.15)
                        .ignoresSafeArea()
                    ProgressView("Please wait...")
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(16)
                }
            }
        }
        // ✅ Cuando se loguea, mostramos el Home
        .fullScreenCover(isPresented: $isAuthenticated) {
            HomeViewModel()
        }
    }
    
    // MARK: - Lógica fake de login
    
    private func handleLogin() {
        authError = nil
        
        guard !loginEmail.isEmpty, !loginPassword.isEmpty else {
            authError = "Please enter email and password."
            return
        }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            
            if loginEmail.lowercased() == demoEmail.lowercased(),
               loginPassword == demoPassword {
                
                withAnimation(.easeInOut(duration: 0.35)) {
                    isAuthenticated = true
                }
            } else {
                authError = "Invalid email or password."
            }
        }
    }
    
    // MARK: - Lógica fake de registro con validaciones
    
    private func handleRegister() {
        authError = nil
        
        // Campos vacíos
        guard !registerEmail.isEmpty,
              !registerPassword.isEmpty,
              !registerConfirmPassword.isEmpty,
              !registerUserName.isEmpty else {
            authError = "All fields are required."
            return
        }
        
        // Email simple válido
        guard isValidEmail(registerEmail) else {
            authError = "Please enter a valid email."
            return
        }
        
        // Largo de contraseña
        guard registerPassword.count >= 6 else {
            authError = "Password must have at least 6 characters."
            return
        }
        
        // Coincidencia
        guard registerPassword == registerConfirmPassword else {
            authError = "Passwords do not match."
            return
        }
        
        isLoading = true
        
        // Simulamos llamada a servidor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            
            // 🎉 Registro ok → lo logueamos directo
            withAnimation(.easeInOut(duration: 0.35)) {
                isAuthenticated = true
            }
        }
    }
    
    // MARK: - Validación básica de email
    
    private func isValidEmail(_ email: String) -> Bool {
        // Simple: algo@algo.algo
        let pattern = #"^\S+@\S+\.\S+$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}

// MARK: - Auth Header (Ajustado para mejor centrado)

struct AuthHeader: View {
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            // Logo y Círculo
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AquaUI.blue, AquaUI.lightBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width:120,height:120)
                Image("AquaMateLogo")
                    .resizable()
                    .scaledToFit()
                    .padding(10)
            }
            .frame(width: 70, height: 70) // Contenedor del logo, centrado por defecto
            Spacer()
            // Títulos
            VStack(alignment: .center, spacing: 4) { // Cambiado a .center para centrar textos
                Text("Aqua Mate")
                    .font(.largeTitle.weight(.semibold))
                    .foregroundColor(AquaUI.primaryGreen)
                    // .padding() // Eliminado padding innecesario aquí
                
                Text("Don’t let your plants dry out")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))
                    // .padding() // Eliminado padding innecesario aquí
            }
            // .padding(.top, 16) // Añadir espacio si es necesario después del logo
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

// MARK: - Login Form

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

// MARK: - Register Form

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

// MARK: - Tip Card

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
