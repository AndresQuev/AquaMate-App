//
//  AuthHeader.swift
//  AquaMate
//
//  Created by Andrés Quevedo on 15/12/2025.
//

import SwiftUI

struct AuthHeader: View {
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            // Logo y Círculo
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AquaUI.blue, AquaUI.lightBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width:120,height:120)
                Image("AquaMateLogo")
                    .resizable()
                    .scaledToFit()
                    .padding(10)
            }
            .frame(width: 70, height: 70) // Contenedor del logo, centrado por defecto
            Spacer()
            // Títulos
            VStack(alignment: .center, spacing: 4) { // Cambiado a .center para centrar textos
                Text("Aqua Mate")
                    .font(.largeTitle.weight(.semibold))
                    .foregroundColor(AquaUI.primaryGreen)
                    // .padding() // Eliminado padding innecesario aquí
                
                Text("Don’t let your plants dry out")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))
                    // .padding() // Eliminado padding innecesario aquí
            }
            // .padding(.top, 16) // Añadir espacio si es necesario después del logo
        }
    }
}

#Preview {
    AuthHeader()
}
