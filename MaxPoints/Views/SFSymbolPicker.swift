//
//  SFSymbolPicker.swift
//  MaxPoints
//
//  Created by Max Hakin on 28/07/2024.
//

import SwiftUI

struct SFSymbolPicker: View {
    @Binding var selectedSymbolName: String
    @Environment(\.presentationMode) var presentationMode

    // List of SF Symbols
    let symbols = ["star", "heart", "circle", "flame", "bolt", "person", "car", "book", "bell", "leaf"]

    var body: some View {
        NavigationView {
            List(symbols, id: \.self) { symbol in
                HStack {
                    Image(systemName: symbol)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding()
                    
                    Text(symbol)
                        .padding()
                }
                .onTapGesture {
                    selectedSymbolName = symbol
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Select an Icon")
        }
    }
}

