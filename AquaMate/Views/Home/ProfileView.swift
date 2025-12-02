import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - User Data
    @State private var fullName: String = "Ana Suárez"
    @State private var username: String = "ansuarez"
    @State private var email: String = "ana.suarez@example.com"
    @State private var age: String = "31"
    @State private var plantCount: String = "18"
    
    // MARK: - UI State
    @State private var showLogoutAlert: Bool = false
    @State private var showEditProfile: Bool = false
    
    var body: some View {
        ZStack {
            AquaUI.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // MARK: - HEADER (Fixed Avatar Circle)
                    HStack(spacing: 18) {
                        ZStack(alignment: .bottomTrailing) {
                            
                            
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 85, height: 85)
                                .foregroundColor(AquaUI.blue)
                            
                            // Subscription badge (small and aligned)
                            Text("FREE")
                                .font(.caption2.weight(.semibold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 2)
                                .offset(x: 6, y: 6)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(fullName)
                                .font(.title2.weight(.semibold))
                                .foregroundColor(AquaUI.primaryGreen)
                            
                            Text("@\(username)")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                            
                            HStack(spacing: 6) {
                                Image(systemName: "leaf.fill")
                                    .foregroundColor(AquaUI.primaryGreen)
                                Text("\(plantCount) plants")
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            showEditProfile = true
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: "pencil")
                                    .font(.title3)
                                Text("Edit")
                                    .font(.caption2.weight(.semibold))
                            }
                            .padding(10)
                            .foregroundColor(AquaUI.blue)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 10)
                    
                    // MARK: - INFO CARD
                    VStack(spacing: 0) {
                        sectionHeader(title: "Personal Information")
                        
                        infoRow(icon: "person.fill", title: "Full Name", value: fullName)
                        infoRow(icon: "envelope.fill", title: "Email", value: email)
                        infoRow(icon: "person.crop.square", title: "Username", value: username)
                        infoRow(icon: "calendar", title: "Age", value: age)
                        infoRow(icon: "leaf.fill", title: "Number of Plants", value: plantCount, addDivider: false)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 6)
                    )
                    .padding(.horizontal, 20)
                    
                    // MARK: - Logout Button
                    Button {
                        showLogoutAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Log out")
                                .font(.headline)
                            Spacer()
                        }
                        .padding()
                        .foregroundColor(.red)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.red.opacity(0.8), lineWidth: 1)
                                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 30)
                }
                .padding(.vertical, 20)
            }
        }
        .navigationTitle("My Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadUserData)
        .alert("Log out", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Log out", role: .destructive) { performLogout() }
        } message: {
            Text("Are you sure you want to log out?")
        }
        .fullScreenCover(isPresented: $showEditProfile) {
            VStack(spacing: 20) {
                Text("Edit Profile")
                    .font(.title2.weight(.semibold))
                Spacer()
                Button("Close") { showEditProfile = false }
            }
            .padding()
        }
    }
    
    // MARK: - Subviews
    
    private func sectionHeader(title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline.weight(.semibold))
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
    
    private func infoRow(
        icon: String,
        title: String,
        value: String,
        addDivider: Bool = true
    ) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .frame(width: 28)
                    .foregroundColor(AquaUI.primaryGreen.opacity(0.9))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(value)
                        .font(.body.weight(.medium))
                }
                
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color(white: 0.995))
            
            if addDivider {
                Divider().padding(.leading, 56)
            }
        }
    }
    
    // MARK: - Data
    
    private func loadUserData() {
        // Keep your data loading logic if needed
    }
    
    private func performLogout() {
        UserDefaults.standard.removeObject(forKey: "userSession")
        dismiss()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView()
        }
    }
}
