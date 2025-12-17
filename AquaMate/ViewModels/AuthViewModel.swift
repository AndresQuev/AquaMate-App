import SwiftUI
import Combine

@MainActor
final class AuthViewModel: ObservableObject {

    //UI State
    @Published var isLogin: Bool = true
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var authError: String?

    //Login fields
    @Published var loginEmail: String = ""
    @Published var loginPassword: String = ""

    //Register fields
    @Published var registerEmail: String = ""
    @Published var registerPassword: String = ""
    @Published var registerConfirmPassword: String = ""
    @Published var registerUserName: String = ""

    //Demo credentials
    private let demoEmail = "user@aquamate.com"
    private let demoPassword = "123456"

    //Actions

    func login() {
        authError = nil

        guard !loginEmail.isEmpty, !loginPassword.isEmpty else {
            authError = "Please enter email and password."
            return
        }

        isLoading = true

        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)

            isLoading = false

            if loginEmail.lowercased() == demoEmail.lowercased(),
               loginPassword == demoPassword {
                isAuthenticated = true
            } else {
                authError = "Invalid email or password."
            }
        }
    }


    func register() {
        authError = nil

        guard !registerEmail.isEmpty,
              !registerPassword.isEmpty,
              !registerConfirmPassword.isEmpty,
              !registerUserName.isEmpty else {
            authError = "All fields are required."
            return
        }

        guard isValidEmail(registerEmail) else {
            authError = "Please enter a valid email."
            return
        }

        guard registerPassword.count >= 6 else {
            authError = "Password must have at least 6 characters."
            return
        }

        guard registerPassword == registerConfirmPassword else {
            authError = "Passwords do not match."
            return
        }

        isLoading = true

        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            isLoading = false
            isAuthenticated = true
        }
    }


    //Helpers

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^\S+@\S+\.\S+$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}
