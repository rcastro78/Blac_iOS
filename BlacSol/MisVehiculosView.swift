//
//  MisVehiculosView.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 13/12/24.
//
import SwiftUI


struct MisVehiculosView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = MisUnidadesViewModel()
    @State private var navigateToMap = false
    @State private var navigateToHome = false
    @State private var navigateToGeofence = false
    @AppStorage("token") var token: String = ""
    @AppStorage("username") var username: String = ""
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 12) {
                    // Título
                    Text("Mis Unidades")
                        .font(.custom("Gilroy-Bold", size: 24))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    // Barra de búsqueda
                    TextField("Buscar unidad", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)

                    // Lista de unidades filtradas
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                            ForEach(viewModel.unidades.filter { unidad in
                                searchText.isEmpty || unidad.nombreVehiculo.lowercased().contains(searchText.lowercased())
                            }) { unidad in
                                StatusCard(
                                    code: unidad.nombreVehiculo,
                                    dateTime: unidad.userLocalTime,
                                    status: unidad.statusVehicule,
                                    location: unidad.address,
                                    speed: unidad.speed,
                                    onStatusCardClick: {
                                        UserDefaults.standard.set(unidad.id, forKey: "deviceId")
                                        UserDefaults.standard.set(unidad.latitude, forKey: "unidad_latitude")
                                        UserDefaults.standard.set(unidad.longitude, forKey: "unidad_longitude")
                                        UserDefaults.standard.set(unidad.nombreVehiculo, forKey: "nombreVehiculo")
                                        UserDefaults.standard.set(unidad.statusVehicule, forKey: "statusVehiculo")
                                        UserDefaults.standard.set(unidad.userLocalTime, forKey: "userLocalTime")
                                        UserDefaults.standard.set(unidad.address, forKey: "address")
                                        UserDefaults.standard.set(unidad.speed, forKey: "speed")
                                        navigateToMap = true
                                    }
                                )
                            }
                        }
                        .padding()
                    }

                    Spacer(minLength: 60) // Deja espacio para los botones flotantes
                }

                // Botones flotantes
                VStack {
                    Spacer()
                    HStack {
                        // Botón izquierdo
                        Button(action: {
                            navigateToHome = true
                        }) {
                            Image(systemName: "house.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                        .padding(.leading)

                        Spacer()

                        // Botón derecho
                        Button(action: {
                            navigateToGeofence = true
                        }) {
                            Image("fence")
                                .renderingMode(.template) 
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                        .padding(.trailing)
                    }
                    .padding(.bottom)
                }
            }
            .onAppear {
                Task {
                    let u = UserDefaults.standard.string(forKey: "username") ?? ""
                    let getVehicleRequest = GetVehicleRequest(
                        usuario: u,
                        fechaIni: getTodayDate() + "000000",
                        fechaFin: getTodayDate() + "235959"
                    )
                    let t = UserDefaults.standard.string(forKey: "token") ?? ""
                    await viewModel.getUnidades(token: t, getVehicleRequest: getVehicleRequest)
                }
            }

            NavigationLink(destination: HistorialVehiculoView(), isActive: $navigateToMap) {
                EmptyView()
            }
            NavigationLink(destination: MenuPrincipalView(), isActive: $navigateToHome) {
                EmptyView()
            }
            
            NavigationLink(destination: GeocercasView(), isActive: $navigateToGeofence) {
                                EmptyView()
                            }
        }
    }

    func getTodayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: Date())
    }
}
