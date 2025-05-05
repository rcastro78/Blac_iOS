//
//  PolygonalGeoFenceMapScreen.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 3/5/25.
//


import SwiftUI
import GoogleMaps
import CoreLocation

struct PolygonalGeofenceConsultaView: View {
    var name: String
    var puntosGeocerca: [CLLocationCoordinate2D] // Lista de puntos de la geocerca
    @Environment(\.presentationMode) var presentationMode
    @State private var cameraPosition = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 16)
    
    var body: some View {
        VStack {
            // Mapa (60% del alto)
            PolygonalGoogleMapView(cameraPosition: $cameraPosition, puntosGeocerca: puntosGeocerca)
                .frame(height: UIScreen.main.bounds.height * 0.6)

            // Texto informativo y campos
            VStack {
                Text("La geocerca se ha dibujado con los puntos predefinidos.")
                    .font(.body)
                    .padding()

                Spacer()

                Text(name)
                    .font(.headline)
                    .padding()

                // Botones
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancelar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .padding()
        }
    }
}

struct PolygonalGoogleMapView: UIViewRepresentable {
    @Binding var cameraPosition: GMSCameraPosition
    var puntosGeocerca: [CLLocationCoordinate2D]

    func makeUIView(context: Context) -> GMSMapView {
        // Si la lista de puntos no está vacía, obtenemos la primera coordenada para centrar la cámara.
        var initialCameraPosition = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 9)  // Valor por defecto
        if let firstPoint = puntosGeocerca.first {
            initialCameraPosition = GMSCameraPosition.camera(withLatitude: firstPoint.latitude, longitude: firstPoint.longitude, zoom: 14)
        }

        let mapView = GMSMapView(frame: .zero, camera: initialCameraPosition)

        // Activar interacciones del usuario
        mapView.isUserInteractionEnabled = true
        mapView.settings.zoomGestures = true
        mapView.settings.scrollGestures = true

        // Dibujar la geocerca con los puntos pasados
        if !puntosGeocerca.isEmpty {
            let path = GMSMutablePath()

            for punto in puntosGeocerca {
                path.add(punto)
            }

            // Crear el polígono con el path
            let polygon = GMSPolygon(path: path)
            polygon.strokeColor = .blue
            polygon.fillColor = UIColor.blue.withAlphaComponent(0.2)
            polygon.strokeWidth = 2
            DispatchQueue.main.async {
                polygon.map = mapView
            }

            // Mover la cámara a la primera coordenada del polígono con un zoom de 9
            let cameraUpdate = GMSCameraUpdate.setTarget(puntosGeocerca.first!, zoom: 9)
            DispatchQueue.main.async {
                mapView.animate(with: cameraUpdate)
            }
        }

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Actualizar la cámara según el valor de cameraPosition
        if let firstPoint = puntosGeocerca.first {
            let cameraUpdate = GMSCameraUpdate.setTarget(firstPoint, zoom: 14)
            uiView.animate(with: cameraUpdate)
        }

        // También actualizar la cámara con el valor de cameraPosition
        uiView.camera = cameraPosition
    }
}
