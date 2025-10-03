//
//  SearchPopularListView.swift
//  lobo1
//
//  Created by alumno on 17/1/25.
//
import SwiftUI
import SwiftData

struct SearchPopularListView: View {
    @ObservedObject var viewModel: CryptoViewModel
    @State private var popularList: [CryptoCurrency] = []
    @State private var textoBuscado = ""
    @State private var cargados = false
    @State private var euro = true
    @State private var resultados: [CryptoCurrency] = []
    @State private var buscando = false

    var body: some View {
        NavigationStack {
            VStack {
                // Barra de búsqueda + botón de búsqueda
                HStack {
                    TextField("Buscar monedas", text: $textoBuscado)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        performSearch()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    
                    // Botón de limpiar búsqueda
                    if buscando {
                        Button(action: {
                            clearSearch()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                }

                if buscando {
                    searchResultsView()
                } else {
                    popularListView()
                }
            }
            .navigationTitle("Buscar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EuroPicker(viewModel: viewModel, euro: $euro)
                }
            }
        }
        .onAppear {
            loadPopularCoins()
        }
        .tint(Color.red)
    }

    // Vista de resultados de búsqueda
    @ViewBuilder
    private func searchResultsView() -> some View {
        if resultados.isEmpty {
            Text("No se encontraron resultados para '\(textoBuscado)'")
                .foregroundColor(.gray)
                .italic()
                .padding()
        } else {
            List {
                ForEach(resultados, id: \.id) { coin in
                    SearchPopularRowView(crypto: coin, euro: euro)
                }
            }
        }
    }

    // Vista de monedas populares
    @ViewBuilder
    private func popularListView() -> some View {
        HStack {
            Text("Monedas recomendadas: ")
                .font(.headline)
            Image(systemName: "flame.fill")
                .foregroundColor(.orange)
        }
        Text("Aquí están las monedas más populares. Para buscar una específica, usa la barra de arriba.")
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding(.bottom, 10)

        List {
            ForEach(popularList) { currency in
                SearchPopularRowView(crypto: currency, euro: euro)
            }
        }
        .listRowSpacing(12.0)
        .contentMargins(.top, 6)
    }

    // Ejecutar búsqueda cuando el usuario presione el botón
    private func performSearch() {
        if textoBuscado.isEmpty {
            clearSearch()
            return
        }

        buscando = true // Cambia la vista a los resultados de búsqueda

        viewModel.searchCoins(query: textoBuscado) { matches in
            DispatchQueue.main.async {
                resultados = matches
            }
        }
    }

    // Volver a la vista de monedas populares
    private func clearSearch() {
        textoBuscado = ""
        resultados = []
        buscando = false
    }

    // Cargar monedas populares
    private func loadPopularCoins() {
        euro = viewModel.isEuro()
        if !cargados { //Verifica si los datos han sido cargados
            viewModel.loadPopularCoins {
                DispatchQueue.main.async { //si ya han sido cargados
                    popularList = viewModel.getPopularCoins()
                    cargados = true
                }
            }
        }
    }
}

