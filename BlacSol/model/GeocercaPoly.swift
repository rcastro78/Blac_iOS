//
//  GeocercaPoly.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 1/5/25.
//
import Foundation

struct GeocercaPolygon: Identifiable, Codable {
    let id: String // representa 'nombre_geocerca'
    let anchoTraza: String
    let colorBorde: String
    let colorRelleno: String
    let coordsPolygon: [String]
    let opacidadRelleno: String

    enum CodingKeys: String, CodingKey {
        case id = "nombre_geocerca"
        case anchoTraza = "ancho_traza"
        case colorBorde = "color_borde"
        case colorRelleno = "color_relleno"
        case coordsPolygon = "coords_polygon"
        case opacidadRelleno = "opacidad_relleno"
    }

    // Método para convertir los strings de coordenadas a [[Double]]
    func parseCoords() -> [[Double]] {
        return coordsPolygon.map {
            $0.split(separator: ",").compactMap { Double($0) }
        }
    }
}

struct GeocercaPolygonResponse: Codable {
    let geocercas: [GeocercaPolygon]?
}

struct GeocercaPolygonRequest: Codable {
    let usuario: String
    let typeGeocerca: String = "POLYGON"
}
