//
//  MenuPrincipalView.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 12/12/24.
//
import SwiftUI
import Combine
import Foundation


struct MenuPrincipalView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateMyVehicle = false
    @State private var navigateToGeofence = false
    @AppStorage("token") var token: String = ""
    @AppStorage("username") var username: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 12) {
                    Text("Hola \(username)")
                        .font(.custom("Gilroy-Medium", size: 24))
                    
                    HStack {
                        Image("estrellas")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(12)
                            .frame(width: UIScreen.main.bounds.width * 0.2)

                        Text("Conecta con tus vehículos y consulta su posición e historial de ruta cuando quieras.")
                            .font(.custom("Gilroy-Regular", size: 14))
                            .lineLimit(3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
                    .frame(height: 64)
                    .padding(.horizontal)

                    LocalizaVehiculoView {
                        navigateMyVehicle = true
                    }
                    .padding(8)

                    Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .navigationBarBackButtonHidden(true)
                
                

                // Botón de WhatsApp en la esquina inferior derecha
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            let url = URL(string: "https://wa.me/525510481042")! // Reemplaza con tu número de WhatsApp
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Image("ic_whatsapp") // Asegúrate de tener este ícono en tus assets
                                .resizable()
                                .frame(width: 56, height: 56)
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
            }

            NavigationLink(destination: MisVehiculosView(), isActive: $navigateMyVehicle) {
                EmptyView()
            }
        }
    }
}

#Preview {
    MenuPrincipalView()
}
