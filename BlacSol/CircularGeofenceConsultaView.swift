//
//  CircularGeofenceConsultaView.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 3/5/25.
//

import SwiftUI
import GoogleMaps
struct CircularGeofenceConsultaView: View {
    let name: String
    let radius: Double
    let center: CLLocationCoordinate2D
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            GoogleMapCircConsultaView(center: center, radius: radius)
                .frame(height: UIScreen.main.bounds.height * 0.6)
                .edgesIgnoringSafeArea(.top)

            VStack(alignment: .leading, spacing: 20) {
                Text(name)
                    .font(.custom("Gilroy-Medium", size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cerrar")
                        .foregroundColor(.white)
                        .font(.custom("Gilroy-Medium", size: 16))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(10)
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

struct GoogleMapCircConsultaView: UIViewRepresentable {
    let center: CLLocationCoordinate2D
    let radius: Double

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withTarget: center, zoom: 12)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        print("Radio \(radius)")
        // Habilitar gestos de interacción
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = true
        mapView.isUserInteractionEnabled = true

        // Agregar círculo
        let circle = GMSCircle(position: center, radius: radius)
        circle.fillColor = UIColor.blue.withAlphaComponent(0.2)
        circle.strokeColor = .blue
        circle.strokeWidth = 2
        circle.map = mapView

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Nada que actualizar por ahora
    }
}
