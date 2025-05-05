//
//  ItemGeocerca.swift
//  BlacSol
//
//  Created by Rafael David Castro Luna on 16/12/24.
//
import SwiftUI


struct ItemGeocercaView: View {
    var forma: Int = 1
    var nombreGeocerca: String = "Mi Geocerca"
    var onItemClick: () -> Void = {}
    var onBasureroClick: () -> Void = {}

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeocercaCardView(action: onItemClick) {
            HStack(spacing: 12) {
                // Ícono de la forma
                ColumnView(forma: forma, onItemClick: onItemClick)
                    .frame(width: UIScreen.main.bounds.width * 0.05)
                    .frame(minHeight: 60)

                // Nombre de la geocerca
                NameColumnView(nombreGeocerca: nombreGeocerca, onItemClick: onItemClick)
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                    .frame(minHeight: 60)

                // Icono de eliminar
                TrashColumnView(onBasureroClick: onBasureroClick)
                    .frame(width: UIScreen.main.bounds.width * 0.05)
                    .frame(minHeight: 60)
            }
            .padding(.horizontal, 12)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .cornerRadius(12)
            .shadow(color: colorScheme == .dark ? Color.black.opacity(0.1) : Color.gray.opacity(0.1), radius: 4, x: 0, y: 2)
            .frame(maxWidth: UIScreen.main.bounds.width - 48)
        }
    }
}

struct ColumnView: View {
    var forma: Int
    var onItemClick: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: iconName(for: forma))
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.blue)
                .onTapGesture {
                    onItemClick()
                }
            Spacer()
        }
    }

    private func iconName(for forma: Int) -> String {
        switch forma {
        case 1:
            return "circle"
        case 2:
            return "square"
        case 3:
            return "triangle"
        default:
            return "questionmark.circle"
        }
    }
}

struct NameColumnView: View {
    var nombreGeocerca: String
    var onItemClick: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            Text(nombreGeocerca)
                .font(.custom("Gilroy-Medium", size: 14))
                .lineLimit(1)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .truncationMode(.tail)
                .onTapGesture {
                    onItemClick()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxHeight: .infinity)
        .padding(.vertical, 10)
    }
}

struct TrashColumnView: View {
    var onBasureroClick: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "trash.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundColor(.red)
                .onTapGesture {
                    onBasureroClick()
                }
            Spacer()
        }
    }
}

struct GeocercaCardView<Content: View>: View {
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
