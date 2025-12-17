import SwiftUI

struct AuthView: View {

    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        NavigationStack {
            ZStack {

                AquaUI.background
                    .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {

                        AuthHeader()

                        AuthSegmentedControl(isLogin: $viewModel.isLogin)

                        VStack(spacing: 20) {
                            if viewModel.isLogin {
                                LoginForm(
                                    userEmail: $viewModel.loginEmail,
                                    userPassword: $viewModel.loginPassword,
                                    isLoading: viewModel.isLoading,
                                    errorMessage: viewModel.authError,
                                    onLogin: viewModel.login
                                )
                            } else {
                                RegisterForm(
                                    email: $viewModel.registerEmail,
                                    password: $viewModel.registerPassword,
                                    confirmPassword: $viewModel.registerConfirmPassword,
                                    userName: $viewModel.registerUserName,
                                    isLoading: viewModel.isLoading,
                                    errorMessage: viewModel.authError,
                                    onRegister: viewModel.register
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

                if viewModel.isLoading {
                    Color.black.opacity(0.15)
                        .ignoresSafeArea()
                    ProgressView("Please wait...")
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(16)
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.isAuthenticated) {
            HomeView()
        }
    }
}
