//
//  PolugonGeocercaView.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 2/5/25.
//
import SwiftUI
import GoogleMaps
import CoreLocation

struct PolygonGeofenceView: View {
    let maxPoints:Int
    @State private var name: String = ""
    @State private var descr: String = ""
    @StateObject private var locationManager = LocationManager()
    @StateObject var viewModel = GeocercaViewModel()
    @State private var navigateToGeocercas: Bool = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var polygonPoints: [CLLocationCoordinate2D] = []
    @State private var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
     // Puedes cambiar esto a 5, 6, 7, 8 para más lados

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    GooglePolygonMapView(
                        center: $centerCoordinate,
                        maxPoints: maxPoints,
                        onUpdatePoints: { updatedPoints in
                            self.polygonPoints = updatedPoints
                        }
                         
                    )
                    .frame(height: UIScreen.main.bounds.height * 0.6)

                    VStack(alignment: .leading, spacing: 16) {
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
                            }

                            Button(action: {
                                guard polygonPoints.count == maxPoints else {
                                    alertMessage = "Debes seleccionar \(maxPoints) puntos en el mapa."
                                    showAlert = true
                                    return
                                }
                            
                                let coords: [String] = polygonPoints.map { "\($0.latitude),\($0.longitude)" }
                                
                                
                                Task {
                                    let usuario = UserDefaults.standard.string(forKey: "username") ?? ""
                                    let token = UserDefaults.standard.string(forKey: "token") ?? ""
                                    let geocercaPolygon = GeocercaPoligonal(coordsPolygon: coords)
                                    var gruposGeocerca: [String] = []
                                    gruposGeocerca.append(usuario)
                                    gruposGeocerca.append("Vehículos de Blac")
                                    
                                    let geocerca = SetGeocercaPolyRequest(anchoTraza: "30", colorBorde: "#0000FF", colorRelleno: "#0000FF", descripcionGeocerca: descr, geocercaPolygon: geocercaPolygon, gruposGeocerca: gruposGeocerca, nameGeocerca: name, opacidadRelleno: "30", typeGeocerca: "POLYGON", usuario: usuario)
                                    
                                    await viewModel.createPolyGeofence(token: token, body: geocerca, onSuccess: {
                                        alertMessage = "Geocerca de \(maxPoints) puntos creada correctamente"
                                           showAlert = true
                                           navigateToGeocercas = true
                                        
                                    }, onError: {error in
                                        alertMessage = "Error al crear la geocerca: \(error)"
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
            }
        }
        .navigationDestination(isPresented: $navigateToGeocercas) {
            GeocercasView()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Resultado"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        
        .onReceive(locationManager.$location) { location in
            if let loc = location {
                centerCoordinate = loc
            }
        }
    }
}



struct GooglePolygonMapView: UIViewRepresentable {
    @Binding var center: CLLocationCoordinate2D
    let maxPoints: Int
    let onUpdatePoints: ([CLLocationCoordinate2D]) -> Void


    class Coordinator: NSObject, GMSMapViewDelegate {
        var points: [CLLocationCoordinate2D] = []
        var mapView: GMSMapView?
        var polygon: GMSPolygon?
        let maxPoints: Int
        let onUpdatePoints: ([CLLocationCoordinate2D]) -> Void

        init(maxPoints: Int, onUpdatePoints: @escaping ([CLLocationCoordinate2D]) -> Void) {
            self.maxPoints = maxPoints
            self.onUpdatePoints = onUpdatePoints
        }

        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            guard points.count < maxPoints else { return }
            points.append(coordinate)
            self.mapView = mapView
            updatePolygon()
            onUpdatePoints(points)
        }

        func updatePolygon() {
            guard let mapView = mapView else { return }
            mapView.clear()

            for point in points {
                let marker = GMSMarker(position: point)
                marker.map = mapView
            }

            if points.count >= 3 {
                let path = GMSMutablePath()
                points.forEach { path.add($0) }

                let polygon = GMSPolygon(path: path)
                polygon.strokeColor = .blue
                polygon.fillColor = UIColor.blue.withAlphaComponent(0.3)
                polygon.strokeWidth = 3
                polygon.map = mapView

                self.polygon = polygon
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(maxPoints: maxPoints, onUpdatePoints: onUpdatePoints)
    }

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withTarget: center, zoom: 16.0)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        context.coordinator.mapView = mapView
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Opcional: recentra si cambia la ubicación
        let currentTarget = uiView.camera.target
        if currentTarget.latitude != center.latitude || currentTarget.longitude != center.longitude {
            let camera = GMSCameraUpdate.setTarget(center, zoom: 16.0)
            uiView.animate(with: camera)
        }
    }
}
