//
//  MiVehiculoView.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 12/12/24.
//

import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    let latitude = UserDefaults.standard.string(forKey: "unidad_latitude") ?? "0.0"
    let longitude = UserDefaults.standard.string(forKey: "unidad_longitude") ?? "0.0"

    func makeUIView(context: Context) -> GMSMapView {
        // Safely unwrap latitude and longitude to avoid force unwrapping
        guard let lat = Double(latitude), let lon = Double(longitude) else {
            fatalError("Invalid coordinates")
        }

        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 16)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true // Habilitar la ubicación del usuario

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        marker.title = "Ubicacion de la unidad" // Título del marcador
        marker.snippet = "" // Subtítulo del marcador
        marker.map = mapView // Asignar el marcador al mapa

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Aquí puedes actualizar el mapa si es necesario (por ejemplo, actualizar la ubicación)
    }
}

struct MiVehiculoMapView: View {
    @State private var navigateToHistory = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            NavigationStack {
                Spacer().frame(height: 8)
                
                // GoogleMapView que ocupa el 70% de la pantalla
                StatusCard(
                    code: UserDefaults.standard.string(forKey: "nombreVehiculo") ?? "",
                    dateTime: UserDefaults.standard.string(forKey: "userLocalTime") ?? "",
                    status:  UserDefaults.standard.string(forKey: "statusVehiculo") ?? "",
                    location:  UserDefaults.standard.string(forKey: "address") ?? "",
                    speed:  UserDefaults.standard.string(forKey: "speed") ?? "")
                
                Spacer().frame(height: 16)
                
                GoogleMapView()
                    .frame(height: UIScreen.main.bounds.height * 0.6) // Ocupa el 60% de la altura de la pantalla
                    .edgesIgnoringSafeArea(.top) // Ignorar la parte superior de la pantalla (estatus bar)
                
                // Aquí puedes agregar más vistas debajo del mapa si es necesario
                VStack {
                    Spacer()
                    
                    Button(action: {
                        navigateToHistory = true
                    }) {
                        Image("hourglass") // Ensure the asset name is correct
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                            .padding()
                    }
                    Spacer()
                }
            }
            
            // NavigationLink tied to navigateToHistory state
            NavigationLink(destination: HistorialVehiculoView(), isActive: $navigateToHistory) {
                EmptyView()
            }
        }
    }
}


