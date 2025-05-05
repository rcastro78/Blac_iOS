//
//  StatusCard.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 13/12/24.
//
import SwiftUI

struct StatusCard: View {
    var code: String = "TR-304"
    var dateTime: String = "25/Nov/2024 17:15"
    var status: String = "Detenido"
    var location: String = "Supercarretera México - Querétaro"
    var speed: String = "0.0 Km/h"
    var onStatusCardClick: () -> Void = {}

    var statusText: String {
        switch status {
        case "STOPPED":
            return "Detenido"
        case "MOVING":
            return speed
        default:
            return status
        }
    }

    var body: some View {
        CardView(action: onStatusCardClick) {
            VStack(alignment: .leading, spacing: 8) {
                // Línea superior
                Text(code)
                    .font(.custom("Gilroy-Medium", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(isDarkMode() ? .blue : .blue)

                // Segunda línea: Fecha y estado
                HStack {
                    Text(dateTime)
                        .font(.custom("Gilroy-Regular", size: 16))
                        .foregroundColor(isDarkMode() ? .black : .gray)
                    Spacer()
                    Text(statusText)
                        .font(.custom("Gilroy-Regular", size: 16))
                        .foregroundColor(isDarkMode() ? .black : .gray)
                }

                // Tercera línea: Ubicación
                Text(location)
                    .font(.custom("Gilroy-Regular", size: 16))
                    .foregroundColor(isDarkMode() ? .black : .gray)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(8)
        }
        .frame(height: 120)
        .padding(4)
    }

    private func isDarkMode() -> Bool {
        UIScreen.main.traitCollection.userInterfaceStyle == .dark
    }
}

struct CardView<Content: View>: View {
    let action: () -> Void
    let content: Content

    init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }

    var body: some View {
        Button(action: action) {
            content
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct StatusCard_Previews: PreviewProvider {
    static var previews: some View {
        StatusCard()
    }
}
