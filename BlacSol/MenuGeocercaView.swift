//
//  MenuGeocercaView.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 3/5/25.
//
import SwiftUI
import Foundation
struct MenuGeocercaView: View {
    

    @State private var navigateToCircleGeofence = false
    @State private var navigateToSquareGeofence = false
    @State private var navigateToPentaGeofence = false
    @State private var navigateToHexaGeofence = false
    @AppStorage("token") var token: String = ""
    @AppStorage("username") var username: String = ""
    
    var body: some View {
        //NavigationStack {
            ZStack {
                VStack(spacing: 12) {
                    Text("Selecciona la forma de tu geocerca")
                        .font(.custom("Gilroy-Medium", size: 24))
                    
                    
                    GeocercaCircleView {
                        navigateToCircleGeofence = true
                    }
                    .padding(8)
                    Spacer()
                    
                    GeocercaCuadradaView {
                        navigateToSquareGeofence = true
                    }
                    .padding(8)
                    Spacer()
                    
                    GeocercaPentaView {
                        navigateToPentaGeofence = true
                    }
                    .padding(8)
                    Spacer()
                    
                    GeocercaHexaView {
                        navigateToHexaGeofence = true
                    }
                    .padding(8)
                    Spacer()
                    
                }//fin vstack
                
                .frame(maxHeight: .infinity, alignment: .top)
                //.navigationBarBackButtonHidden(true)
                
                
                
                
            }//fin zstack
            
            NavigationLink(destination: CircularGeofenceView(), isActive: $navigateToCircleGeofence) {
                EmptyView()
            }
            
            NavigationLink(destination: PolygonGeofenceView(maxPoints:4), isActive: $navigateToSquareGeofence) {
                EmptyView()
            }
            
            NavigationLink(destination: PolygonGeofenceView(maxPoints:5), isActive: $navigateToPentaGeofence) {
                EmptyView()
            }
            
            NavigationLink(destination: PolygonGeofenceView(maxPoints:6), isActive: $navigateToHexaGeofence) {
                EmptyView()
            }
            
            
            //fin nav}
        
        
        
    }
}
