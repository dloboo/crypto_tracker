//
//  SearchPopularRowView.swift
//  lobo1
//
//  Created by alumno on 17/1/25.
//

import SwiftUI
import SwiftData

struct SearchPopularRowView: View {
    var crypto: CryptoCurrency
    var euro: Bool
    @State private var precioUltimas24h: [Price] = []
    @State private var porcentaje: Double = 0
    @State private var cargando = true

    var body: some View {
        VStack {
            HStack {
                // Imagen de la moneda
                AsyncImage(url: crypto.imageURL) { cryptoImage in
                    cryptoImage.resizable()
                } placeholder: {
                    Image(systemName: "dollarsign.circle")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                        .padding()
                }
                .frame(width: 32.0, height: 32.0)

                // Información de la moneda
                VStack {
                    HStack {
                        Text(crypto.name)
                            .font(.title)
                        Spacer()
                    }
                    HStack {
                        Text(crypto.symbol)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                }
                .onAppear {
                    crypto.updateDetails()
                }

                Spacer()

                // Precio y cambio porcentual
                VStack(alignment: .trailing) {
                    if let currentPrice = euro ? crypto.currentPrice?["eur"] : crypto.currentPrice?["usd"] {
                        Text(PriceFormatter.formatPrice(value: currentPrice, euro: euro))
                            .font(.headline)
                            .foregroundColor(.primary)
                    }

                    if cargando {
                        ProgressView()
                            .onAppear {
                                fetchHistoricalPrices()
                            }
                    } else {
                        HStack {
                            if porcentaje > 0 {
                                Image(systemName: "triangle.fill")
                                    .foregroundColor(.green)
                                Text("+" + String(format: "%.2f%%", porcentaje))
                                    .foregroundColor(.green)
                            } else if porcentaje == 0 {
                                Text(String(format: "%.2f%%", porcentaje))
                                    .foregroundColor(.gray)
                            } else {
                                Image(systemName: "triangle.fill")
                                    .rotationEffect(.degrees(180))
                                    .foregroundColor(.red)
                                Text(String(format: "%.2f%%", porcentaje))
                                    .foregroundColor(.red)
                            }
                        }
                        .font(.caption)
                    }
                }
            }
            Divider()
            InterestingButton(crypto: crypto)
        }
    }

    private func fetchHistoricalPrices() {
        APIService.getHistoricalPrices(coinId: crypto.APIid, currency: euro ? "eur" : "usd", days: 1) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.precioUltimas24h = data
                    self.porcentaje = calculatePercentageChange()
                    self.cargando = false
                case .failure(let error):
                    print("Error fetching historical prices: \(error)")
                    self.cargando = false
                }
            }
        }
    }

    private func calculatePercentageChange() -> Double {
        //Obtiene el precio de las ultimas 24h y el precio mas reciente para calcular el porcentaje
        guard let firstPrice = precioUltimas24h.first?.value, let lastPrice = precioUltimas24h.last?.value else {
            return 0.0
        }
        return ((lastPrice - firstPrice) / firstPrice) * 100
    }
}
