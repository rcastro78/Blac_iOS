//
//  GeocercaViewModel.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 2/5/25.
//
import SwiftUI
import Combine
class GeocercaViewModel: ObservableObject {
    func createCircleGeofence(
            token: String,
            body: SetGeocercaCircleRequest,
            onSuccess: @escaping () -> Void,
            onError: @escaping (String) -> Void
    ) {
        guard let jsonData = try? JSONEncoder().encode(body) else {
                onError("Error al codificar el request")
                return
            }
        
        guard let url = URL(string: Constants.API.setGeocercaCircleEndpoint) else {
                onError("URL inválida")
                return
            }

            // Armar el request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue(token, forHTTPHeaderField: "token")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
        

            // Enviar la solicitud
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    onError("Error de red: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    onError("Respuesta inválida")
                    return
                }

                if httpResponse.statusCode == 200 {
                    onSuccess()
                } else {
                    let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Error desconocido"
                    onError("Error del servidor: \(httpResponse.statusCode) - \(errorMessage)")
                }
            }.resume()
        
    }
    
    
    func createPolyGeofence(
            token: String,
            body: SetGeocercaPolyRequest,
            onSuccess: @escaping () -> Void,
            onError: @escaping (String) -> Void
    ) {
        guard let jsonData = try? JSONEncoder().encode(body) else {
                onError("Error al codificar el request")
                return
            }
        
        guard let url = URL(string: Constants.API.setGeocercaPolyEndpoint) else {
                onError("URL inválida")
                return
            }

        // Armar el request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

            // Enviar la solicitud
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    onError("Error de red: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    onError("Respuesta inválida")
                    return
                }

                if httpResponse.statusCode == 200 {
                    onSuccess()
                } else {
                    let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Error desconocido"
                    onError("Error del servidor: \(httpResponse.statusCode) - \(errorMessage)")
                }
            }.resume()
        
    }
    
    
    
    func deleteGeocerca(token: String,body:EliminarGeocercaRequest,
                        onSuccess: @escaping (EliminarGeocercaResponse) -> Void,
                        onError: @escaping (String) -> Void){
        
        guard let jsonData = try? JSONEncoder().encode(body) else {
                onError("Error al codificar el request")
                return
            }
        
        guard let url = URL(string: Constants.API.deleteGeoCercasEndpoint) else {
                onError("URL inválida")
                return
            }

        // Armar el request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(token, forHTTPHeaderField: "token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

            // Enviar la solicitud
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    onError("Error de red: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    onError("Respuesta inválida")
                    return
                }

                if httpResponse.statusCode == 200 {
                            do {
                                let decodedResponse = try JSONDecoder().decode(EliminarGeocercaResponse.self, from: data!)
                                onSuccess(decodedResponse)
                            } catch {
                                onError("Error al decodificar respuesta: \(error.localizedDescription)")
                            }
                        } else {
                            let errorMessage = String(data: data!, encoding: .utf8) ?? "Error desconocido"
                            onError("Error del servidor: \(httpResponse.statusCode) - \(errorMessage)")
                        }
            }.resume()
        
    }
    
}

