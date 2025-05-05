//
//  MisGeocercasPoligonales.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 1/5/25.
//
import SwiftUI
import Combine
class MisGeocercasPoligonalesViewModel: ObservableObject {
    @Published var geocercasPoligonales: [GeocercaPolygon] = []
    func getGeocercasPoligonales(token: String, geocercasPolyRequest: GeocercaPolygonRequest) async {
        guard let url = URL(string: Constants.API.geocercasEndpoint) else {
            print("URL no válida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "token")
        
        guard let httpBody = try? JSONEncoder().encode(geocercasPolyRequest) else {
            print("Error al serializar el cuerpo de la solicitud")
            return
        }
        request.httpBody = httpBody

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error en la solicitud: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Sin datos en la respuesta")
                return
            }

            do {
                let response = try JSONDecoder().decode(GeocercaPolygonResponse.self, from: data)
                if let geo = response.geocercas {
                    print("Geocercas recibidas: \(geo.count)")
                    DispatchQueue.main.async {
                        self.geocercasPoligonales = geo
                    }
                } else {
                    print("No se encontraron geocercas poligonales")
                }
            } catch {
                print("Error decodificando el JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
}
