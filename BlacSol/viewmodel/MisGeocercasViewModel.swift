//
//  MisGeocercasViewModel.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 14/12/24.
//
import SwiftUI
import Combine
class MisGeocercasViewModel: ObservableObject {
    @Published var geocercasCirculares: [GeocercaCircle] = []
    
    // Geocercas circulares
    func getGeocercasCirculares(token: String, geocercasCircleRequest: GeocercaCircleRequest) async {
        guard let url = URL(string: Constants.API.geocercasEndpoint) else {
            print("URL no válida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "token")
        
        guard let httpBody = try? JSONEncoder().encode(geocercasCircleRequest) else {
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
                let response = try JSONDecoder().decode(GeocercaCircleResponse.self, from: data)
                if let geo = response.geocercas {
                    print("Geocercas recibidas: \(geo.count)")
                    DispatchQueue.main.async {
                        self.geocercasCirculares = geo
                    }
                } else {
                    print("No se encontraron geocercas circulares")
                }
            } catch {
                print("Error decodificando el JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    //Fin circulares
    
}
