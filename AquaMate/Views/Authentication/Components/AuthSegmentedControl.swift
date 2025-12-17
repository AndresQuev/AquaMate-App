//
//  AuthSegmentedControl.swift
//  AquaMate
//
//  Created by Andrés Quevedo on 15/12/2025.
//

import SwiftUI

struct AuthSegmentedControl: View {
    @Binding var isLogin: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isLogin = true
                }
            } label: {
                Text("Log In")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .foregroundColor(isLogin ? .black : .white)
                    .background(
                        Group {
                            if isLogin {
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(AquaUI.secondaryGreen)
                            } else {
                                Color.clear
                            }
                        }
                    )
            }
            .buttonStyle(.plain)
            
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isLogin = false
                }
            } label: {
                Text("Register")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .foregroundColor(!isLogin ? .black : .white)
                    .background(
                        Group {
                            if !isLogin {
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(AquaUI.secondaryGreen)
                            } else {
                                Color.clear
                            }
                        }
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(4)
        .background(
            Capsule()
                .fill(AquaUI.primaryGreen)
        )
    }
}

