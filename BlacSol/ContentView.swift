//
//  ContentView.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 9/12/24.
//

import SwiftUI
import Combine
import Foundation
import CoreLocation
import AuthenticationServices


struct ContentView: View {
        @State private var username: String = "ADMIN_PATI"
        @State private var password: String = "TAP23PATY"
        @State private var passwordVisible: Bool = false
        @State private var navigateToMainMenu = false
        @State private var navigateToMap = false
        @State private var isAuthenticated = false
    @StateObject private var locationManager = LocationManager()
    @AppStorage("token") var token: String = ""
    @AppStorage("username") var user: String = ""
        @StateObject private var viewModel = LoginViewModel()
    
        var body: some View {
            
            NavigationStack{
                ScrollView {
                    
                    VStack {
                        Spacer().frame(height: 24)
                        
                        // Logo
                        HStack {
                            Spacer()
                            Image("loginavatar") // Asegúrate de tener esta imagen en tus assets
                                .resizable()
                                .frame(width: 92, height: 92)
                            Spacer()
                        }
                        
                        Spacer().frame(height: 12)
                        
                        // Header Text
                        Text("Inicia Sesión")
                            .font(.custom("Gilroy-Bold", size: 24))
                            .foregroundColor(.white)
                            .padding(.top, 48)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Spacer().frame(height: 24)
                        
                        // Username TextField
                        HStack {
                            // Imagen a la izquierda
                            Image(systemName: "person.circle")
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
                            
                            // TextField con suficiente espacio
                            TextField("Usuario", text: $username)
                                .font(.custom("Gilroy-Regular", size: 18))
                                .padding(.vertical, 12) // Padding vertical ajustado
                        }
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal, 8)
                        
                        Spacer().frame(height: 12)
                        
                        // Password TextField
                        HStack {
                            if passwordVisible {
                                TextField("Contraseña", text: $password)
                                    .font(.custom("Gilroy-Regular", size: 18))
                                    .padding(.leading, 8)
                                    .padding(.vertical, 4)// Espaciado interno desde el borde izquierdo
                            } else {
                                SecureField("Contraseña", text: $password)
                                    .font(.custom("Gilroy-Regular", size: 18))
                                    .padding(.leading, 8)
                                    .padding(.vertical, 4)// Espaciado interno desde el borde izquierdo
                            }
                            Spacer() // Empuja el botón hacia el extremo derecho
                            Button(action: {
                                passwordVisible.toggle()
                            }) {
                                Image(systemName: passwordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8) // Espaciado interno desde el borde derecho
                            }
                        }
                        .padding(8) // Padding interno general
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal, 8)
                        
                        Spacer().frame(height: 16)
                        
                        // Login Button
                        Button(action: {
                            UserDefaults.standard.set(username, forKey: "username")
                            loginAction()
                        }) {
                            Text("Continuar")
                                .font(.custom("Gilroy-Regular", size: 18))
                                .frame(maxWidth: .infinity, minHeight: 56)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.bottom, 16)
                        
                        // Register Button
                        Button(action: {
                            registerAction()
                        }) {
                            Text("Registrarse")
                                .font(.custom("Gilroy-Regular", size: 18))
                                .frame(maxWidth: .infinity, minHeight: 56)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                        .padding(.bottom, 16)
                        
                        // Forgot Password Button
                        Button(action: {
                            forgotPasswordAction()
                        }) {
                            Text("Olvidé mi contraseña")
                                .font(.custom("Gilroy-Regular", size: 18))
                                .frame(maxWidth: .infinity, minHeight: 56)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                        
                        SignInWithAppleButton(
                            .signIn,
                            onRequest: { request in
                                request.requestedScopes = [.fullName, .email]
                            },
                            onCompletion: { result in
                                switch result {
                                case .success(let authResults):
                                    // Procesar autenticación con Apple
                                    print("Authorization successful: \(authResults)")
                                    // Puedes guardar el token o realizar una navegación
                                case .failure(let error):
                                    print("Authorization failed: \(error.localizedDescription)")
                                }
                            }
                        )
                        .signInWithAppleButtonStyle(.black)
                        .frame(height: 56)
                        .cornerRadius(8)
                        .padding(.bottom, 16)
                        
                        
                        
                        
                        // WhatsApp Button
                        HStack {
                            Spacer()
                            Button(action: {
                                openWhatsApp("+525510481042")
                            }) {
                                Image("ic_whatsapp") // Asegúrate de agregar esta imagen
                                    .resizable()
                                    .frame(width: 64, height: 64)
                                    .clipShape(Circle())
                            }
                            .padding(.trailing, 16)
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                    .padding(12)
                    
                }.background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color.black]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                .onAppear(){
                    locationManager.requestPermission()
                }
                
                
                NavigationLink(destination: MenuPrincipalView(), isActive: $navigateToMainMenu) {
                    EmptyView()
                }
                
                NavigationLink(destination: MisVehiculosView(), isActive: $navigateToMap) {
                    EmptyView()
                }
                
            }
            
            
            
        }

        // Acciones
    func loginAction() {
        let request = LoginRequest(usuario: username, password: password)

        viewModel.login(loginRequest: request) { result in
            switch result {
            case .success(let response):
                navigateToMainMenu = true
            case .failure(let error):
                print("Login failed with error: \(error)")
            }
        }
    }

        func registerAction() {
            // Lógica para registrar un nuevo usuario
            print("Ir a la pantalla de registro")
        }

        func forgotPasswordAction() {
            // Lógica para recuperar contraseña
            print("Recuperar contraseña")
        }

        func openWhatsApp(_ phone: String) {
            // Lógica para abrir WhatsApp
            print("Abriendo WhatsApp con el número: \(phone)")
        }
}

#Preview {
    ContentView()
}




