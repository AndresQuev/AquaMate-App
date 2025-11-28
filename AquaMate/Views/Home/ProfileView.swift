import SwiftUI

struct ProfileView: View {
    // Dismiss para cerrar el fullScreenCover presentado desde Auth
    @Environment(\.dismiss) private var dismiss
    
   
    @State private var fullName: String = ""
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var age: String = ""
    @State private var plantsCount: String = ""
    
    // UI state
    @State private var showLogoutAlert: Bool = false
    @State private var showSavedToast: Bool = false
    
    var body: some View {
        ZStack {
            // Fondo igual que en Auth
            AquaUI.background
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // Header similar al AuthHeader (logo + texts)
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [AquaUI.blue, AquaUI.lightBlue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .padding(12)
                                .frame(width: 76, height: 76)
                                .foregroundColor(.white.opacity(0.95))
                        }
                        
                        Text(fullName)
                            .font(.title2.weight(.semibold))
                            .foregroundColor(AquaUI.primaryGreen)
                        
                        Text("Plan free")
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.6))
                    }
                    .padding(.top, 6)
                    
                    // Card con campos (mismo estilo a tus formularios)
                    VStack(spacing: 16) {
                        // Título sección
                        HStack {
                            Text("Datos personales")
                                .font(.headline.weight(.semibold))
                            Spacer()
                        }
                        
                        // Campos
                        labeledField(icon: "person.fill", placeholder: "Nombre completo", text: $fullName)
                        labeledField(icon: "at", placeholder: "Email", text: $email, keyboard: .emailAddress)
                        labeledField(icon: "person.crop.square", placeholder: "User name", text: $userName)
                        labeledField(icon: "calendar", placeholder: "Edad", text: $age, keyboard: .numberPad)
                        labeledField(icon: "leaf.fill", placeholder: "Cantidad de plantas", text: $plantsCount, keyboard: .numberPad)
                        
                        // Botones: Guardar y Cerrar sesión
                        HStack(spacing: 12) {
                            Button(action: saveProfile) {
                                HStack {
                                    Text("Guardar")
                                        .font(.headline)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(AquaUI.blue)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                            }
                            
                            Button(action: { showLogoutAlert = true }) {
                                HStack {
                                    Image(systemName: "door.right.hand.open")
                                    Text("Cerrar sesión")
                                        .font(.headline)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(RoundedRectangle(cornerRadius: 14).stroke(AquaUI.primaryGreen, lineWidth: 1))
                            }
                        }
                        .padding(.top, 6)
                    }
                    .padding(18)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 16)
                }
                .padding(.vertical, 28)
            }
            
            // Toast simple al guardar
            if showSavedToast {
                VStack {
                    Spacer()
                    Text("Perfil guardado")
                        .font(.subheadline)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                        .shadow(radius: 6)
                        .padding(.bottom, 36)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationTitle("Mi Perfil")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Cerrar sesión", isPresented: $showLogoutAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Cerrar sesión", role: .destructive) {
                performLogout()
            }
        } message: {
            Text("¿Estás seguro que querés cerrar sesión?")
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private func labeledField(icon: String, placeholder: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 28)
            
            TextField(placeholder, text: text)
                .keyboardType(keyboard)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.95))
        .cornerRadius(12)
    }
    
    // MARK: - Actions
    
    private func saveProfile() {
   
        let profile: [String: String] = [
            "fullName": fullName,
            "userName": userName,
            "email": email,
            "age": age,
            "plantsCount": plantsCount
        ]
        UserDefaults.standard.set(profile, forKey: "cachedProfile")
        
        withAnimation(.easeInOut(duration: 0.25)) {
            showSavedToast = true
        }
        // ocultar toast automáticamente
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation { showSavedToast = false }
        }
    }
    
    private func performLogout() {
        // Limpiar credenciales locales (si usás otra clave, cambiala)
        UserDefaults.standard.removeObject(forKey: "userSession")
        UserDefaults.standard.removeObject(forKey: "cachedProfile")
        
        // Cerrar la vista presentada (esto hace que el .fullScreenCover se cierre)
        dismiss()
    }
}

// MARK: - Preview

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView()
        }
    }
}
