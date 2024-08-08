//
//  RepeatingBackgroundView.swift
//  MaxPoints
//
//  Created by Max Hakin on 07/08/2024.
//

import SwiftUI

struct RepeatingPatternView: View {
    var symbolName: String
    var size: CGFloat = 100
    var spacing: CGFloat = 10
    
    var body: some View {
        GeometryReader { geometry in
            let columns = Int(geometry.size.width / (size + spacing))
            let rows = Int(geometry.size.height / (size + spacing))
            
            ForEach(0..<rows, id: \.self) { row in
                ForEach(0..<columns, id: \.self) { column in
                    Image(systemName: symbolName)
                        .resizable()
                        .frame(width: size, height: size)
                        .position(x: CGFloat(column) * (size + spacing) + size / 2,
                                  y: CGFloat(row) * (size + spacing) + size / 2)
                }
            }
        }
        .clipped()
    }
}
