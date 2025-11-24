//
//  AuthViewModel.swift
//  AquaMate
//
//  Created by Andrés Quevedo on 27/10/2025.
//

import SwiftUI

struct AuthViewModel: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}



//Log In Header
struct LoginHeader:View {
    var body: some View {
        VStack{
            Image("AquaMateLogo")
                .resizable()
                .aspectRatio(contentMode:.fit)
                .frame(width:120,height:120)
                .padding(.bottom,10)
            Text("Aqua Mate")
                .bold()
                .font(.title)
                .foregroundStyle(.green)
            Text("Don't let your plants dry out")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

//Log In Form

struct LoginForm:View {
    @Binding var userEmail:String
    @Binding var userPassword:String
    var body: some View {
        VStack(spacing:15){
            HStack {
                
                Image(systemName: "envelope.fill")
                    .foregroundColor(.gray)
                TextField("Email Address:", text: $userEmail)
                    .keyboardType(.emailAddress)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            HStack{
                Image(systemName: "lock.fill")
                SecureField("Password: ", text: $userPassword)
                
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            //Log in button
            Button {
                print("Log In button tapped.")
            } label: {
                Text("Log In")
                    .bold()
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity) // Ocupa todo el ancho
                    .frame(height: 50)
                    .background(Color.green.opacity(0.8)) // Usa tu color principal
                    .cornerRadius(10)
            }
            
            Text("or login with")
                .foregroundColor(.black)
            
            
            HStack(spacing: 15) {
                // Google button (Usando estilo de botón con borde o fondo blanco)
                Button {} label: {
                    HStack {
                        Image("GoogleIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Google")
                            .foregroundColor(.black)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                }
                
                // Apple Button
                Button {} label: {
                    HStack {
                        Image(systemName: "apple.logo")
                            .resizable()
                            .frame(width: 18, height: 22)
                            .foregroundColor(.white)
                        Text("Apple")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                }
            }
            
            
            
            
        }
        .padding()
        
        
        
    }
}

struct CreateAccount:View {
    var body: some View {
        
        Text("Don't have an account?")
        NavigationLink(destination: RegisterView()){
            
            
            Text("Create here!")
                .bold()
                .foregroundColor(.green)
            
            
            
            
        }
    }
}


struct RegisterHeader:View {
    var body: some View {
        VStack{
                
            Image("Cactus")
                .resizable()
                .aspectRatio(contentMode:.fit)
                .frame(width:120,height:120)
                .padding(.bottom,10)
                
            Text("Aqua Mate")
                .bold()
                .font(.title)
                .foregroundStyle(.green)
            Text("Don't let your plants dry out")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

struct RegisterForm:View {
    @Binding var email:String
    @Binding var password:String
    @Binding var confirmPassword:String
    @Binding var userName:String
    var body: some View {
        
        VStack(spacing:15){
            
            //Email
            HStack {
                Image(systemName: "envelope.fill")
                TextField("Email: ", text: $email)
                    .keyboardType(.emailAddress)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            //Password
            
            HStack {
                Image(systemName: "lock.fill")
                SecureField("Password: ", text:$password)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            //Confirm Password
            
            HStack {
                Image(systemName: "lock.badge.checkmark.fill")
                SecureField("Confirm Passowrd: ", text:$confirmPassword)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            //User Name
            
            HStack {
                Image(systemName: "person.fill")
                TextField("User Name: ", text:$userName)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            //Register Button
            Button {
                print("Register button tapped.")
            } label: {
                Text("Register")
                    .bold()
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity) // Ocupa todo el ancho
                    .frame(height: 50)
                    .background(Color.green.opacity(0.8)) // Usa tu color principal
                    .cornerRadius(10)
            }
        }
        .padding()
        
        
        
    }
}
struct AlreadyHaveAnAccount:View {
    var body: some View {
        VStack{
            Text("Already have an account?")
            
            NavigationLink(destination:LoginView()) {
                Text("Log in here")
                    .bold()
                    .foregroundColor(.green)
            }
        }
    }
}
struct Tip:View {
    var body: some View {
        Text("¿You know what?")
            .bold()
            .font(.title3)
            .foregroundStyle(.orange)
        
        
        Text("Here goes a tip")
    }
}


#Preview {
    AuthViewModel()
}
