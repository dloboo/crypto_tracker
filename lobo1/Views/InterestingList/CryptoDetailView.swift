//
//  CryptoDetailView.swift
//  lobo1
//
//  Created by alumno on 16/1/25.
//


import SwiftUI
import Charts

struct CryptoDetailView: View {
    @State private var prices: [Price] = []
    @State private var dias = 1
    @State private var euro: Bool = false
    @State private var cargandoprecios = true
    @State private var porcentaje: Double = 0
    
    @State private var isExpanded = false

    @ObservedObject var viewModel: CryptoViewModel
    var crypto: CryptoCurrency

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Título de la criptomoneda con imagen
                    HStack(spacing: 12) {
                        if let imageURL = crypto.imageURL {
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40) // Tamaño ajustado de la imagen
                                    .clipShape(Circle()) // Imagen circular
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 40, height: 40)
                            }
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(crypto.name)
                                .font(.largeTitle)
                                .bold()
                            Text(crypto.symbol.uppercased())
                                .font(.title2)
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                        HStack(spacing: 8) {
                            InterestingButton(crypto: crypto)
                            Button(action: {
                                toggleFavoritos(for: crypto)
                            }) {
                                Image(systemName: crypto.isFavorite ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Descripción de la criptomoneda
                    if let coinDescription = crypto.coinDescription {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Descripción:")
                                .font(.headline)
                            Text(coinDescription)
                                .lineLimit(isExpanded ? nil : 3)
                                .font(.body)
                            
                            Button(action: {
                                isExpanded.toggle()
                            }) {
                                Text(isExpanded ? "Ver menos" : "Ver más")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    //Informacion adicional de la criptomoneda
                    if let marketCapRank = crypto.marketRank,
                       let volume = crypto.volume?["usd"] {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Ranking del mercado:")
                                    .bold()
                                Text("#\(marketCapRank)")
                            }
                            
                            HStack {
                                Text("Volumen Total:")
                                    .bold()
                                Text(PriceFormatter.formatPrice(value: volume, euro: euro))
                            }
                        }
                        .padding(.horizontal)
                    }

                    
                    // Información sobre precios y gráficos
                    if cargandoprecios || (crypto.currentPrice?.isEmpty ?? true) {
                        ProgressView("Cargando datos...")
                    } else if prices.isEmpty {
                        Text("No hay datos disponibles.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        
                        //Visualizar precio y subida o bajada
                        HStack {
                            Text(PriceFormatter.formatPrice(value: crypto.currentPrice?[euro ? "eur" : "usd"] ?? 0, euro: euro))
                                .font(.title)
                            Spacer()
                            let color: Color = porcentaje > 0 ? .green : (porcentaje < 0 ? .red : .gray)
                            let rotation: Double = porcentaje < 0 ? 180 : 0
                            Image(systemName: "triangle.fill")
                                .rotationEffect(.degrees(rotation))
                                .foregroundStyle(color)
                            Text(String(format: "%+.2f%%", porcentaje))
                                .foregroundStyle(color)
                        }
                        .padding()

                        
                        Chart {
                            ForEach(prices, id: \.timestamp) { price in
                                LineMark(
                                    x: .value("Tiempo", dateFromTimestamp(timestamp: price.timestamp)),
                                    y: .value("Precio", price.value)
                                )
                                .foregroundStyle(.blue)
                            }
                        }
                        .chartXScale(domain: xScaleDomain())
                        .chartYScale(domain: yScaleDomain())
                        .frame(height: 200)
                        .padding()
                        
                        Picker("Rango de días", selection: $dias) {
                            Text("90 días").tag(90)
                            Text("1mes").tag(30)
                            Text("1semana").tag(7)
                            Text("24h").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                    }
                }
            }
            .toolbar {
                // Botón para actualizar los detalles
                ToolbarItem {
                    Button(action: {
                        crypto.updateDetails()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .onChange(of: dias, initial: true) { _, newValue in
                fetchData(days: newValue, currency: (euro ? "eur" : "usd"))
            }
            .onChange(of: euro) { _, newValue in
                fetchData(days: dias, currency: (newValue ? "eur" : "usd"))
            }
            .onAppear {
                euro = viewModel.isEuro()
                crypto.updateDetails()
            }
        }
    }


    private func fetchData(days: Int, currency: String) {
        APIService.getHistoricalPrices(coinId: crypto.APIid, currency: currency, days: days) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.prices = data
                    self.porcentaje = calcularPorcentaje()
                    self.cargandoprecios = false
                case .failure(let error):
                    print("Error fetching data:", error)
                    self.cargandoprecios = false
                }
            }
        }
    }
    
    // calculates scale of x axis
    private func xScaleDomain() -> ClosedRange<Date> {
        let timestamps = prices.map { Date(timeIntervalSince1970: TimeInterval($0.timestamp / 1000)) }
        guard let minTime = timestamps.min(), let maxTime = timestamps.max() else {
            return Date()...Date()
        }
        return minTime...maxTime
    }
    
    private func toggleFavoritos(for currency: CryptoCurrency) {
            currency.isFavorite.toggle()
        }

    // calculates scale of y axis
    private func yScaleDomain() -> ClosedRange<Double> {
        guard let minValue = prices.map({ $0.value }).min(),
              let maxValue = prices.map({ $0.value }).max() else {
            return 0...1
        }
        return minValue...maxValue
    }
    
    // calculates percentage change from start to end of graph
    private func calcularPorcentaje() -> Double {
       return ((prices.last!.value - prices.first!.value) / prices.first!.value) * 100
    }
    
    // calculates date given timestamp
    private func dateFromTimestamp(timestamp: Int) -> Date {
        Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
    }
}
