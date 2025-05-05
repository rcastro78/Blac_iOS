//
//  SetGeocercaCircleRequest.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 1/5/25.
//
import Foundation

struct SetGeocercaCircleRequest: Codable {
    let ancho_traza: String
    let color_borde: String
    let color_relleno: String
    let descripcion_geocerca: String
    let geocerca_circle: GeoCircle
    let grupos_geocerca: [String]
    let name_geocerca: String
    let opacidad_relleno: String
    let typeGeocerca: String
    let usuario: String
}

struct GeoCircle: Codable {
    let coords_circle: String
    let radio_circle: String
}
