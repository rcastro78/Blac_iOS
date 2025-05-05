//
//  GeocercasView.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 16/12/24.
//
import SwiftUI
import Combine
import CoreLocation

struct CircularGeofenceDetail {
    let name: String
    let radius: Double
    let center: CLLocationCoordinate2D
}


struct PolygonalGeofenceDetail {
    let name: String
    var puntosGeocerca: [CLLocationCoordinate2D]
}

struct GeocercasView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = MisGeocercasViewModel()
    @StateObject private var polyViewModel = MisGeocercasPoligonalesViewModel()
    @StateObject private var geocercaViewModel = GeocercaViewModel()
    @State private var selectedGeofence: CircularGeofenceDetail? = nil
    @State private var selectedPolyGeofence: PolygonalGeofenceDetail? = nil
    @State private var navigateToHome = false
    @State private var navigateToGeo = false
    @State private var navigateToMenuGeo = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var navigateToConsultaCircle = false
    @State private var navigateToConsultaPoly = false
    
    // Computed properties para evitar let dentro del body
    private var usuario: String {
        UserDefaults.standard.string(forKey: "username") ?? ""
    }
    
    private var token: String {
        UserDefaults.standard.string(forKey: "token") ?? ""
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Mis límites virtuales")
                    .font(.custom("Gilroy-Medium", size: 20))
                    .padding(.top, 20)
                
                Spacer()
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                        ForEach(viewModel.geocercasCirculares) { geocerca in
                            ItemGeocercaView(
                                forma: 1,
                                nombreGeocerca: geocerca.id,
                                onItemClick: {
                                   
                                    let radio = Double(geocerca.radioCircle) ?? 0.0
                                        let nombre = geocerca.id
                                        let coords = geocerca.coordsCircle.split(separator: ",")
                                        let lat = Double(coords[0]) ?? 0.0
                                        let lon = Double(coords[1]) ?? 0.0
                                
                                        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                                        selectedGeofence = CircularGeofenceDetail(name: nombre, radius: radio, center: center)
                                    
                                    
                                    navigateToConsultaCircle = true
                                    
                                    
                                },
                                onBasureroClick: {
                                    eliminarGeocerca(tipo: "CIRCLE", id: geocerca.id)
                                }
                            )
                            .padding(12)
                            .cornerRadius(18)
                            .shadow(radius: 4)
                        }
                        
                        ForEach(polyViewModel.geocercasPoligonales) { geocerca in
                            ItemGeocercaView(
                                forma: 2,
                                nombreGeocerca: geocerca.id,
                                onItemClick: {
                                    
                                    let nombre = geocerca.id
                                    let coordenadas: [String] = geocerca.coordsPolygon
                                
                                    let latLngList: [CLLocationCoordinate2D]? = coordenadas.compactMap { punto in
                                        let coords = punto.split(separator: ",")
                                        if coords.count == 2,
                                           let lat = Double(coords[0]),
                                           let lng = Double(coords[1]) {
                                            return CLLocationCoordinate2D(latitude: lat, longitude: lng)
                                        } else {
                                            return nil
                                        }
                                    }
                                    
                                    latLngList?.forEach { latLng in
                                        print("\(latLng.latitude), \(latLng.longitude)")
                                    }
                                    
                                    
                                    selectedPolyGeofence = PolygonalGeofenceDetail(name: nombre, puntosGeocerca: latLngList ?? [])
                                    
                                    navigateToConsultaPoly = true
                                   /*
                                    let radio = Double(geocerca.radioCircle) ?? 0.0
                                        let nombre = geocerca.id
                                        let coords = geocerca.coordsCircle.split(separator: ",")
                                        let lat = Double(coords[0]) ?? 0.0
                                        let lon = Double(coords[1]) ?? 0.0
                                
                                        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                                        selectedGeofence = CircularGeofenceDetail(name: nombre, radius: radio, center: center)
                                    
                                    
                                    navigateToConsultaCircle = true
                                    */
                                },
                                onBasureroClick: {
                                    eliminarGeocerca(tipo: "POLYGON", id: geocerca.id)
                                }
                            )
                            .padding(12)
                            .cornerRadius(18)
                            .shadow(radius: 4)
                        }
                    }
                    .padding(.horizontal, 12)
                }
            }
            
            // Botones flotantes
            VStack {
                Spacer()
                HStack {
                    // Botón Home
                    Button(action: {
                        navigateToHome = true
                    }) {
                        Image("home")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .padding()
                            .background(Color.black)
                            .clipShape(Circle())
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                    // Botón Add
                    Button(action: {
                        navigateToMenuGeo = true
                    }) {
                        Image("add")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .padding()
                            .background(Color.black)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 20)
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            fetchGeocercas()
        }
        .navigationDestination(isPresented: $navigateToHome) {
            MenuPrincipalView()
        }
        .navigationDestination(isPresented: $navigateToMenuGeo) {
            MenuGeocercaView()
        }
        
        .navigationDestination(isPresented: $navigateToConsultaCircle) {
                        if let geofence = selectedGeofence {
                            CircularGeofenceConsultaView(
                                name: geofence.name,
                                radius: geofence.radius,
                                center: geofence.center
                            )
                        }
        }
        
        
        
        .navigationDestination(isPresented: $navigateToConsultaPoly) {
            if let geofence = selectedPolyGeofence {
                            PolygonalGeofenceConsultaView(
                                name: geofence.name,
                                puntosGeocerca:geofence.puntosGeocerca
                            )
                        }
        }
        
        
        
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Resultado"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func fetchGeocercas() {
        let geocercasCircleRequest = GeocercaCircleRequest(usuario: usuario)
        let geocercasPoligonoRequest = GeocercaPolygonRequest(usuario: usuario)
        
        Task {
            await viewModel.getGeocercasCirculares(token: token, geocercasCircleRequest: geocercasCircleRequest)
        }
        Task {
            await polyViewModel.getGeocercasPoligonales(token: token, geocercasPolyRequest: geocercasPoligonoRequest)
        }
    }
    
    func eliminarGeocerca(tipo: String, id: String) {
        let request = EliminarGeocercaRequest(usuario: usuario, typeGeocerca: tipo, nameGeocerca: id)
        
        Task {
            await geocercaViewModel.deleteGeocerca(token: token, body: request, onSuccess: {_ in
                fetchGeocercas()
                alertMessage = "Geocerca eliminada correctamente"
                showAlert = true
            }, onError: { _ in
                alertMessage = "Error al eliminar la geocerca"
                showAlert = true
            })
        }
    }
}
