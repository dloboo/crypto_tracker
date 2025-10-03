//
//  EuroToggle.swift
//  lobo1
//
//  Created by Diego Lobo on 14/1/25.
//


import SwiftUI

// Selector para cambiar entre euros y dólares
struct EuroPicker: View {
    @StateObject var viewModel: CryptoViewModel
    @Binding var euro: Bool

    var body: some View {
        Picker("Moneda", selection: $euro) {
            Text("Dólares ($)").tag(false)
            Text("Euros (€)").tag(true)
        }
        .pickerStyle(SegmentedPickerStyle()) // Estilo más visual
        .onChange(of: euro) { newValue in
            viewModel.setEuro(euro: newValue)
        }
        .onAppear {
            euro = viewModel.isEuro()
        }
    }
}

