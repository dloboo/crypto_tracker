//
//  InterestingCryptoRowView.swift
//  lobo1
//
//  Created by alumno on 16/1/25.
//

import SwiftUI
import Charts

struct InterestingCryptoRowView: View {
    @StateObject var viewModel: CryptoViewModel
    var crypto: CryptoCurrency
    var euro: Bool
    @State private var prices: [Price] = []
    @State private var porcentaje: Double = 0
    @State private var cargandoPrecios = true

    var body: some View {
        NavigationLink {
            CryptoDetailView(viewModel: viewModel, crypto: crypto)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    // Imagen y nombre de la moneda
                    AsyncImage(url: crypto.imageURL) { cryptoImage in
                        cryptoImage.resizable()
                    } placeholder: {
                        Image(systemName: "dollarsign.circle")
                            .resizable()
                            .frame(width: 32.0, height: 32.0)
                            .padding()
                    }
                    .frame(width: 32.0, height: 32.0)

                    VStack(alignment: .leading) {
                        Text(crypto.name)
                            .font(.headline)
                        if crypto.isFavorite {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                        if let currentPrice = euro ? crypto.currentPrice?["eur"] : crypto.currentPrice?["usd"] {
                            Text(PriceFormatter.formatPrice(value: currentPrice, euro: euro))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }

                    Spacer()
                }

                // Gráfico y cambio porcentual
                if cargandoPrecios {
                    ProgressView()
                        .onAppear {
                            fetchHistoricalPrices()
                        }
                } else if !prices.isEmpty {
                    Chart {
                        ForEach(prices, id: \.timestamp) { price in
                            LineMark(
                                x: .value("Time", dateFromTimestamp(timestamp: price.timestamp)),
                                y: .value("Price", price.value)
                            )
                            .foregroundStyle(.black)
                        }
                    }
                    .chartXScale(domain: ScaleX())
                    .chartYScale(domain: ScaleY())
                    .frame(height: 50)
                    .padding(.vertical, 4)

                    // Cambio porcentual
                    HStack {
                        if porcentaje > 0 {
                            Image(systemName: "triangle.fill")
                                .foregroundColor(.green)
                            Text("+" + String(format: "%.2f", porcentaje) + "%")
                                .foregroundColor(.green)
                        } else if porcentaje == 0 {
                            Text(String(format: "%.2f", porcentaje) + "%")
                                .foregroundColor(.gray)
                        } else {
                            Image(systemName: "triangle.fill")
                                .rotationEffect(.degrees(180))
                                .foregroundColor(.red)
                            Text(String(format: "%.2f", porcentaje) + "%")
                                .foregroundColor(.red)
                        }
                    }
                    .font(.caption)
                } else {
                    Text("No data")
                        .foregroundColor(.gray)
                }
            }
        }
    }

    private func fetchHistoricalPrices() {
        APIService.getHistoricalPrices(coinId: crypto.APIid, currency: euro ? "eur" : "usd", days: 1) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.prices = data
                    self.porcentaje = calcularPorcentaje()
                    self.cargandoPrecios = false
                case .failure(let error):
                    print("Error fetching historical prices: \(error)")
                    self.cargandoPrecios = false
                }
            }
        }
    }

    private func calcularPorcentaje() -> Double {
        guard let firstPrice = prices.first?.value, let lastPrice = prices.last?.value else {
            return 0.0
        }
        return ((lastPrice - firstPrice) / firstPrice) * 100
    }

    private func dateFromTimestamp(timestamp: Int) -> Date {
        Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
    }

    private func ScaleX() -> ClosedRange<Date> {
        let timestamps = prices.map { Date(timeIntervalSince1970: TimeInterval($0.timestamp / 1000)) }
        guard let minTime = timestamps.min(), let maxTime = timestamps.max() else {
            return Date()...Date()
        }
        return minTime...maxTime
    }

    private func ScaleY() -> ClosedRange<Double> {
        guard let minValue = prices.map({ $0.value }).min(),
              let maxValue = prices.map({ $0.value }).max() else {
            return 0...1
        }
        return minValue...maxValue
    }
}
