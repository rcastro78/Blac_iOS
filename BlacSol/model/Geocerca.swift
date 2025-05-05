//
//  Geocerca.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 14/12/24.
//
struct GeocercaCircle: Identifiable, Codable {
    let id: String // 'id' representa 'nombre_geocerca' en el JSON
    let anchoTraza: String
    let colorBorde: String
    let colorRelleno: String
    let coordsCircle: String
    let opacidadRelleno: String
    let radioCircle: String
    
    enum CodingKeys: String, CodingKey {
        case id = "nombre_geocerca" // 'id' será mapeado a 'nombre_geocerca'
        case anchoTraza = "ancho_traza"
        case colorBorde = "color_borde"
        case colorRelleno = "color_relleno"
        case coordsCircle = "coords_circle"
        case opacidadRelleno = "opacidad_relleno"
        case radioCircle = "radio_circle"
    }
    
    func parseCoords() -> [Double]? {
        return coordsCircle.split(separator: ",").compactMap { Double($0) }
    }
}
    
    // Método personalizado para convertir la cadena 'coordsCircle' en un array de Double
    



struct GeocercaCircleResponse: Codable {
    var geocercas: [GeocercaCircle]?
}

struct GeocercaCircleRequest: Codable {
    let usuario: String
    let typeGeocerca: String = "CIRCLE"
}


struct EliminarGeocercaRequest: Codable {
    let usuario: String
    let typeGeocerca: String
    let nameGeocerca: String
}

struct EliminarGeocercaResponse: Codable {
    let responseCode: String
    let message: String
}

