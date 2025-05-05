//
//  HistorialVehiculoView.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 16/12/24.
//
import SwiftUI
import GoogleMaps

// GoogleMapViewHisto: Vista para mostrar el mapa con los marcadores y polyline
struct GoogleMapViewHisto: UIViewRepresentable {
    var markers: [Historial]
    @State private var navigateHome=false
    func makeUIView(context: Context) -> GMSMapView {
        let initialLatitude = markers.first?.latitude ?? "0.0"
        let initialLongitude = markers.first?.longitude ?? "0.0"
        let camera = GMSCameraPosition.camera(withLatitude: Double(initialLatitude) ?? 0.0,
                                              longitude: Double(initialLongitude) ?? 0.0,
                                              zoom: 10)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true

        // Agregar marcadores y dibujar polyline
        addMarkersAndPolyline(to: mapView)

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Limpiar marcadores y polyline existentes
        uiView.clear()

        // Agregar los nuevos marcadores y dibujar polyline
        addMarkersAndPolyline(to: uiView)
    }

    private func addMarkersAndPolyline(to mapView: GMSMapView) {
        var path = GMSMutablePath()

        // Agregar los marcadores y crear el path para la polyline
        for markerData in markers {
            if let latitude = Double(markerData.latitude),
               let longitude = Double(markerData.longitude) {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                marker.map = mapView

                // Agregar el punto al path de la polyline
                path.add(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }
        }

        // Dibujar la polyline
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .blue
        polyline.strokeWidth = 3.0
        polyline.map = mapView

        // Mover la cámara al último punto
        if let lastMarker = markers.last,
           let latitude = Double(lastMarker.latitude),
           let longitude = Double(lastMarker.longitude) {
            let camera = GMSCameraPosition.camera(withLatitude: latitude,
                                                  longitude: longitude,
                                                  zoom: 14)
            mapView.animate(to: camera)
        }
    }
}

// HistorialVehiculoView: Vista principal donde se muestra la fecha y el mapa
struct HistorialVehiculoView: View {
    @StateObject private var viewModel = HistorialVehiculoViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateHome = false
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @Environment(\.colorScheme) var colorScheme

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: selectedDate)
    }

    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                VStack {
                    Text("Historial").font(.custom("Gilroy-Medium", size: 24))
                        .padding(.top, 20)
                    Spacer()
                    
                    Label {
                        Text(formattedDateFormatted) // Mostrar en formato "dd/MMM/yyyy"
                            .font(.custom("Gilroy-Medium", size: 20))
                            .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: "calendar")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    }
                    .onTapGesture {
                        showDatePicker.toggle()
                    }
                }
                
                .frame(height: UIScreen.main.bounds.height * 0.2)
                Spacer().padding(.bottom, 18)
                
                GoogleMapViewHisto(markers: viewModel.historial)
                    .frame(height: UIScreen.main.bounds.height * 0.6)
                    .edgesIgnoringSafeArea(.top)
                
                VStack {
                    Spacer()
                    Button(action: {
                        navigateHome = true
                    }) {
                        Image("home")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                            .padding()
                    }
                    Spacer()
                }
                .frame(height: UIScreen.main.bounds.height * 0.2)
            }
            .onAppear {
                fetchData(for: selectedDate)
            }
            .sheet(isPresented: $showDatePicker) {
                DatePickerDialog(selectedDate: $selectedDate, showDatePicker: $showDatePicker, fetchData: fetchData, colorScheme: colorScheme)
            }
        }
        
        //.navigationBarBackButtonHidden(true)
        NavigationLink(destination: MenuPrincipalView(), isActive: $navigateHome) {
            EmptyView()
        }
        
        
    }

    private func fetchData(for date: Date) {
        Task {
            let token = UserDefaults.standard.string(forKey: "token")
            let u = UserDefaults.standard.string(forKey: "username")
            let imei = UserDefaults.standard.string(forKey: "deviceId")
            let formattedDate = formattedDateFor(date)
            let getHistoryVehicleRequest = GetHistoVehicleRequest(
                usuario: u ?? "",
                fechaIni: formattedDate + "000000",
                fechaFin: formattedDate + "235959",
                imei: imei ?? ""
            )

            await viewModel.getUnidades(token: token ?? "", getHistoVehicleRequest: getHistoryVehicleRequest)
        }
    }

    private func formattedDateFor(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: date)
    }

    private var formattedDateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM/yyyy"
        return formatter.string(from: selectedDate)
    }
}

// DatePickerDialog: Vista del DatePicker que aparece como un diálogo
struct DatePickerDialog: View {
    @Binding var selectedDate: Date
    @Binding var showDatePicker: Bool
    var fetchData: (Date) -> Void
    var colorScheme: ColorScheme
    var spanishLocale: Locale {
        Locale(identifier: "es_ES")
    }

    var body: some View {
        NavigationStack{
            VStack {
                DatePicker("Seleccionar Fecha", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .environment(\.locale, spanishLocale)
                
                Button("Aceptar") {
                    showDatePicker.toggle() // Cerrar el DatePicker
                    fetchData(selectedDate) // Llamar a fetchData con la fecha seleccionada
                }
                .padding()
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding()
        }
    }
}

