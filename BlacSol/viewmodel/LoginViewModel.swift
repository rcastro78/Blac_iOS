//
//  LoginViewModel.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 13/12/24.
//
import SwiftUI
import Combine
struct LoginRequest: Encodable {
    let usuario: String
    let password: String
}

struct LoginResponse: Decodable {
    let token: String
}

class LoginViewModel: ObservableObject {
    @Published var token: String = ""
    @Published var isAuthenticated = false
    
    func login(loginRequest: LoginRequest, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        // Verifica que la URL sea válida
        guard let url = URL(string: "http://3.17.53.133:3030/mobile/connect/v1/login") else {
            print("URL no válida")
            return
        }

        // Configura el request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("f0ef25e588f380942beeadfc4a5016199e3a849a", forHTTPHeaderField: "credential")

        // Serializa el cuerpo de la solicitud
        guard let httpBody = try? JSONEncoder().encode(loginRequest) else {
            print("Error al serializar el cuerpo de la solicitud")
            return
        }
        request.httpBody = httpBody

        // Realiza la solicitud
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Maneja errores en la solicitud
            if let error = error {
                completion(.failure(error))
                return
            }

            // Verifica que los datos no sean nulos
            guard let data = data else {
                let error = NSError(domain: "com.example.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Sin datos en la respuesta"])
                completion(.failure(error))
                return
            }

            // Decodifica la respuesta
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                DispatchQueue.main.async {
                    self.token = loginResponse.token
                    UserDefaults.standard.set(loginResponse.token, forKey: "token")
                    print("Token: \(self.token)")
                }
                completion(.success(loginResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
