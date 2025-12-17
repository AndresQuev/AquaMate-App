//
//  TipCard.swift
//  AquaMate
//
//  Created by Andrés Quevedo on 15/12/2025.
//

import SwiftUI

struct TipCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Did you know?")
                .font(.headline)
                .foregroundColor(.orange)
            
            Text("Keeping a regular watering schedule helps your plants grow healthier and stronger.")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.7))
            }
        .padding(16)
        .background(AquaUI.softYellow)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    TipCard()
}
