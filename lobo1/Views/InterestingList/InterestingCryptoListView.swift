//
//  InterestingCryptoList.swift
//  lobo1
//
//  Created by alumno on 16/1/25.
//



import SwiftUI
import SwiftData

struct InterestingCryptoListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var cryptoList: [CryptoCurrency]
    @State private var euro: Bool = true
    @ObservedObject var viewModel: CryptoViewModel

    
    var body: some View {
        NavigationStack {
            listView
                .onAppear {
                    euro = viewModel.isEuro()
                    for crypto in cryptoList {
                        crypto.updateDetails()
                    }
                }
                .navigationTitle("Mis Monedas")
                .overlay {
                    if cryptoList.isEmpty {
                        ContentUnavailableView {
                            Label("No tienes monedas en la sección de interés, añádelas mediante la pestaña Buscar", systemImage: "xmark.circle")
                        }

                    }
                }

        }
        .tint(Color.red)
    }
    
    private var listView: some View {
        List {
            // Sección de monedas favoritas
            Section {
                ForEach(sortedFavoritesPrice) { currency in
                    InterestingCryptoRowView(viewModel: viewModel, crypto: currency, euro: euro)
                        .swipeActions(edge: .leading) {
                            Button(action: {
                                toggleFavoritos(for: currency)
                            }) {
                                Label("Unfavorite", systemImage: "star.slash.fill")
                            }
                            .tint(.gray)
                        }
                }
                .onDelete(perform: deleteCrypto)
            } header: {
                ZStack {
                    // Fondo amarillo para el encabezado
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.yellow)
                        .frame(height: 40) // Altura del rectángulo
                        .padding(.horizontal)
                    
                    // Texto del encabezado
                    Text("Favoritas")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }

            // Sección de monedas interesantes
            Section {
                ForEach(sortedNonFavoritesPrice) { currency in
                    InterestingCryptoRowView(viewModel: viewModel, crypto: currency, euro: euro)
                        .swipeActions(edge: .leading) {
                            Button(action: {
                                toggleFavoritos(for: currency)
                            }) {
                                Label("Favorite", systemImage: "star")
                            }
                            .tint(.yellow)
                        }
                }
                .onDelete(perform: deleteCrypto)
            } header: {
                ZStack {
                    // Fondo azul para el encabezado
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                        .frame(height: 40) // Altura del rectángulo
                        .padding(.horizontal)
                    
                    // Texto del encabezado
                    Text("Interesantes")
                        .font(.headline)
                        .foregroundColor(.white) // Texto en blanco para contraste
                }
            }

        }
    }
    
    private func addCryptoToInterested(_ crypto: CryptoCurrency) {
        withAnimation {
            modelContext.insert(crypto)
            try? modelContext.save()
        }
    }

    
    // Ordena las monedas favoritas por precio de mayor a menor
    private var sortedFavoritesPrice: [CryptoCurrency] {
        cryptoList
            .filter { $0.isFavorite }
            .sorted { ($0.currentPrice?[euro ? "eur" : "usd"] ?? 0) > ($1.currentPrice?[euro ? "eur" : "usd"] ?? 0) }
    }

    // Ordena las monedas interesantes por precio de mayor a menor
    private var sortedNonFavoritesPrice: [CryptoCurrency] {
        cryptoList
            .filter { !$0.isFavorite }
            .sorted { ($0.currentPrice?[euro ? "eur" : "usd"] ?? 0) > ($1.currentPrice?[euro ? "eur" : "usd"] ?? 0) }
    }

    
    private func toggleFavoritos(for currency: CryptoCurrency) {
        withAnimation {
            currency.isFavorite.toggle()
            try? modelContext.save()
        }
    }

    private func deleteCrypto(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(cryptoList[index])
            }
        }
    }
}
