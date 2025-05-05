//
//  Evento.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 13/12/24.
//
import Foundation

struct Evento: Codable, Identifiable {
    let id: String
    let event: String
    let userLocalTime: String
    let speed: String
    let altitude: String
    let latitude: String
    let longitude: String
    let address: String
    let statusVehicule: String
    let nombreVehiculo: String

    
    
    enum CodingKeys: String, CodingKey {
        case id = "deviceID"
        case event
        case userLocalTime
        case speed
        case altitude
        case latitude
        case longitude
        case address
        case statusVehicule = "status_vehicule"
        case nombreVehiculo = "nombre_vehiculo"
    }
}




    struct EventosResponse: Codable {
        var eventos: [Evento]?
    }


struct GetVehicleRequest: Codable {
    let usuario: String
    let fechaIni: String
    let fechaFin: String
}


