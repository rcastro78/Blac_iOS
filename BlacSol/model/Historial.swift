//
//  Historial.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 16/12/24.
//
import Foundation


struct GetHistoVehicleRequest:Codable{
    let usuario:String
    let fechaIni:String
    let fechaFin:String
    let imei:String
}

struct Historial: Identifiable, Codable {
    let id: String // Mapeado desde "deviceID"
    let nombreVehiculo: String
    let usuario: String
    let event: String
    let userLocalTime: String
    let userLocalTimeFormat: String
    let latitude: String
    let longitude: String
    let azimuth: String?
    let speed: String
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case id = "deviceID" // Mapeando deviceID a id
        case nombreVehiculo = "nombre_vehiculo"
        case usuario
        case event
        case userLocalTime
        case userLocalTimeFormat
        case latitude
        case longitude
        case azimuth
        case speed
        case address
    }
}

struct EventosHistoryResponse: Codable {
    let eventosHistory: [Historial]?
}
