//
//  LimitesVirtuales.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 12/12/24.
//
import SwiftUI

struct LimitesVirtualesView: View {
    var onItemClick: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 12)

            // Título
            HStack {
                Text("Límites Virtuales")
                    .font(.custom("Gilroy-Medium", size: 20))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .padding(.horizontal, 12)
                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .top)

            // Imagen y espaciado
            HStack {
                Spacer()
                Image("location")
                    .resizable()
                    .scaledToFit()
                    .padding(.trailing, 16)
                    .frame(maxHeight: .infinity)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: 132)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.red, .blue]),
                startPoint: UnitPoint(x: 0.5, y: -0.5), // Simula Offset(0.5f, -0.5f)
                endPoint: .bottomTrailing // Simula Offset.Infinite
            )
        )
        .cornerRadius(6)
        .onTapGesture {
            onItemClick()
        }
    }
}
