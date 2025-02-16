//
//  MarkerView.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

import SwiftUI

// MARK: - MarkerView
struct MarkerView: View {
    var location: LocationResponseEntity
    var isSelected: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: isSelected ? "mappin.circle.fill" : "mappin.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(isSelected ? .green.opacity(0.8) : .blue.opacity(0.8))
                .padding(2)
                .background(Circle().stroke(Color.white, lineWidth: 1))
            Text(location.name)
                .font(.system(size: 12))
                .foregroundColor(.white)
                .padding(5)
                .background(Color.black.opacity(0.7))
                .cornerRadius(5)
        }
    }
}
