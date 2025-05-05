//
//  SetGeocercaPolyRequest.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 2/5/25.
//
struct SetGeocercaPolyRequest: Codable {
    let anchoTraza: String
    let colorBorde: String
    let colorRelleno: String
    let descripcionGeocerca: String
    let geocercaPolygon: GeocercaPoligonal
    let gruposGeocerca: [String]
    let nameGeocerca: String
    let opacidadRelleno: String
    let typeGeocerca: String
    let usuario: String

    enum CodingKeys: String, CodingKey {
        case anchoTraza = "ancho_traza"
        case colorBorde = "color_borde"
        case colorRelleno = "color_relleno"
        case descripcionGeocerca = "descripcion_geocerca"
        case geocercaPolygon = "geocerca_polygon"
        case gruposGeocerca = "grupos_geocerca"
        case nameGeocerca = "name_geocerca"
        case opacidadRelleno = "opacidad_relleno"
        case typeGeocerca
        case usuario
    }
}


struct GeocercaPoligonal: Codable {
    let coordsPolygon: [String]

    enum CodingKeys: String, CodingKey {
        case coordsPolygon = "coords_polygon"
    }
}

