//
//  GeocercaCircular.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 1/5/25.
//
import SwiftUI
import GoogleMaps
import CoreLocation


struct CircularGeofenceView: View {
    @State private var name: String = ""
        @State private var descr: String = ""
        @State private var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        @State private var radius: CLLocationDistance = 100.0
        @StateObject private var locationManager = LocationManager()
        @StateObject var viewModel = GeocercaViewModel()
        @State private var navigateToGeocercas:Bool = false
        @State private var showAlert = false
        @State private var alertMessage = ""
    
    
    // Área = π * r² -> r = sqrt(Área / π) => 25 km² ≈ 2822.74 m
    let maxRadius: CLLocationDistance = 50000.0

    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(spacing: 0) {
                    GoogleCircleMapView(center: $centerCoordinate, radius: $radius)
                        .frame(height: UIScreen.main.bounds.height * 0.6)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Slider para controlar el radio
                        VStack(alignment: .leading) {
                            Text("Radio: \(Int(radius)) m")
                                .font(.headline)
                            Slider(value: $radius, in: 100...maxRadius, step: 100.0)
                        }
                        
                        TextField("Nombre de la geocerca", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 20, weight: .medium))
                        
                        TextField("Descripción", text: $descr)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 20, weight: .medium))
                        
                        Spacer()
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                // Acción cerrar
                            }) {
                                Text("Cerrar")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.black)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white, lineWidth: 1)
                                    )
                            }
                            
                            Button(action: {
                            
                                let geoCircle = GeoCircle(coords_circle: "\(centerCoordinate.latitude), \(centerCoordinate.longitude)",radio_circle: "\(radius)")
                            
                                Task{
                                    let usuario = UserDefaults.standard.string(forKey: "username") ?? ""
                                    let token = UserDefaults.standard.string(forKey: "token") ?? ""
                                    
                                    var gruposGeocerca: [String] = []
                                    gruposGeocerca.append(usuario)
                                    gruposGeocerca.append("Vehículos de Blac")
                                    
                                    let geocerca = SetGeocercaCircleRequest(ancho_traza: "30", color_borde: "#0000FF", color_relleno: "#0000FF", descripcion_geocerca: descr, geocerca_circle: geoCircle, grupos_geocerca: gruposGeocerca, name_geocerca: name, opacidad_relleno: "30", typeGeocerca: "CIRCLE", usuario: usuario)
                                    
                                    await viewModel.createCircleGeofence(token: token, body: geocerca, onSuccess: {
                                        alertMessage = "Geocerca creada correctamente"
                                           showAlert = true
                                           navigateToGeocercas = true
                                        
                                    }, onError: {error in
                                        alertMessage = "Error al crear la geocerca"
                                           showAlert = true
                                           navigateToGeocercas = true
                                    })
                                }
                                
                                
                                
                            }) {
                                Text("Guardar")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                }
                
                .onReceive(locationManager.$location) { location in
                    if let loc = location {
                        centerCoordinate = loc
                    }
                }
                
                .edgesIgnoringSafeArea(.top)
            }
        }
        
        .navigationDestination(isPresented: $navigateToGeocercas) {
            GeocercasView()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Resultado"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"), action: {
                    navigateToGeocercas = true
                })
            )
        }
    }
    
        
    
    
    
        
}


struct GoogleCircleMapView: UIViewRepresentable {
    @Binding var center: CLLocationCoordinate2D
    @Binding var radius: CLLocationDistance

    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleCircleMapView
        var circle: GMSCircle?
        var marker: GMSMarker?

        init(parent: GoogleCircleMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            parent.center = coordinate
            circle?.position = coordinate
            marker?.position = coordinate
        }

        @objc func sliderChanged(_ sender: UISlider) {
            parent.radius = CLLocationDistance(sender.value)
            circle?.radius = CLLocationDistance(sender.value)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withTarget: center, zoom: 16.0)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true

        // Marcador y círculo
        let marker = GMSMarker(position: center)
        marker.map = mapView
        context.coordinator.marker = marker

        let circle = GMSCircle(position: center, radius: radius)
        circle.fillColor = UIColor.blue.withAlphaComponent(0.2)
        circle.strokeColor = UIColor.blue
        circle.strokeWidth = 2
        circle.map = mapView
        context.coordinator.circle = circle

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        uiView.animate(toLocation: center)
        context.coordinator.marker?.position = center
        context.coordinator.circle?.position = center
        context.coordinator.circle?.radius = radius
    }
}
