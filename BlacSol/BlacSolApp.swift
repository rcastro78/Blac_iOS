//
//  BlacSolApp.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 9/12/24.
//

import SwiftUI
import GoogleMaps
@main
struct BlacSolApp: App {
    init(){
        GMSServices.provideAPIKey("AIzaSyDRf9S9CkhBc5-_vcpLAS_E4Xi-SVEc0Tc")
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
