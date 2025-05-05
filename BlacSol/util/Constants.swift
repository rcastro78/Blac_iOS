//
//  Constants.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 16/12/24.
//
struct Constants {
    struct API {
        static let baseURL = "http://3.17.53.133:3030/mobile/connect/v1"
        static let GOOGLE_MAP_KEY="MAP_KEY"
        static let loginEndpoint="\(baseURL)/login"
        static let historialEndpoint="\(baseURL)/get/eventos/history"
        static let geocercasEndpoint="\(baseURL)/get/geocercas"
        static let setGeocercaCircleEndpoint="\(baseURL)set/geocerca"
        static let setGeocercaPolyEndpoint="\(baseURL)set/geocerca"
        static let deleteGeoCercasEndpoint="\(baseURL)delete/geocerca"
    }
}
