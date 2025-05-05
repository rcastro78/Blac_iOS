//
//  MisUnidadesViewModel.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 13/12/24.
//
import SwiftUI
import Combine

class MisUnidadesViewModel: ObservableObject {
    @Published var unidades: [Evento] = [] // Asegúrate de que es un array de 'Evento'

    func getUnidades(token: String, getVehicleRequest: GetVehicleRequest) async{
        guard let url = URL(string: "http://3.17.53.133:3030/mobile/connect/v1/get/eventos") else {
            print("URL no válida")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "token")
        
        guard let httpBody = try? JSONEncoder().encode(getVehicleRequest) else {
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
                let response = try JSONDecoder().decode(EventosResponse.self, from: data)
                if let eventos = response.eventos {
                    print("Eventos recibidos: \(eventos.count)")
                    self.unidades = eventos
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
