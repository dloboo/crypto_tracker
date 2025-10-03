//
//  InterestingButton.swift
//  lobo1
//
//  Created by Diego Lobo on 14/1/25.
//

import SwiftUI
import SwiftData

struct InterestingButton: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var cryptoList: [CryptoCurrency]
    var crypto: CryptoCurrency

    var body: some View {
        Button(action: {
            toggleCrypto()
        }) {
            HStack {
                Text(isInteresting ? "Quitar de Interesantes" : "Añadir a Interesantes")
                Image(systemName: isInteresting ? "xmark.circle.fill" : "checkmark.circle.fill")
                    .foregroundColor(isInteresting ? .red : .blue)



            }
        }
        .tint(isInteresting ? .red : .blue)
    }

    private var isInteresting: Bool {
        cryptoList.contains(where: { $0.APIid == crypto.APIid })
    }

    private func toggleCrypto() {
        withAnimation {
            if isInteresting {
                borrarCrypto()
            } else {
                añadirCrypto()
            }
        }
    }

    private func añadirCrypto() {
        modelContext.insert(crypto)
    }

    private func borrarCrypto() {
        if let existingCrypto = cryptoList.first(where: { $0.APIid == crypto.APIid }) {
            modelContext.delete(existingCrypto)
        }
    }
}

