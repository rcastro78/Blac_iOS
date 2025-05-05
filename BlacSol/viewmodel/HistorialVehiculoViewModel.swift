//
//  HistorialVehiculoViewModel.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 16/12/24.
//
import SwiftUI
import Combine

class HistorialVehiculoViewModel: ObservableObject {
    @Published var historial: [Historial] = []
    func getUnidades(token: String, getHistoVehicleRequest: GetHistoVehicleRequest) async{
        guard let url = URL(string: Constants.API.historialEndpoint) else {
            print("URL no válida")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "token")
        
        guard let httpBody = try? JSONEncoder().encode(getHistoVehicleRequest) else {
            print("Error al serializar el cuerpo de la solicitud")
            return
        }
        request.httpBody = httpBody
        print(request.allHTTPHeaderFields)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return
            }
            
            if let data = data {
                let jsonString = String(data: data, encoding: .utf8)
                print("JSON recibido: \(jsonString ?? "No se puede convertir a String")")
            }
            
            guard let data = data else {
                let error = NSError(domain: "com.example.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Sin datos en la respuesta"])
                
                return
            }
            
            do {
                let response = try JSONDecoder().decode(EventosHistoryResponse.self, from: data)
                if let histo = response.eventosHistory {
                    print("Eventos recibidos: \(histo.count)")
                    self.historial = histo
                } else {
                    print("No se encontraron eventos")
                }
            } catch {
                print("Error decodificando el JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
