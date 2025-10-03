//
//  CryptoTrackerApp.swift
//  lobo1
//
//  Created by Diego Lobo on 29/1/25.
//


import SwiftUI
import SwiftData

@main
struct CryptoTrackerApp: App {
    @StateObject private var viewModel = CryptoViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .modelContainer(Self.createModelContainer())
        }
    }

    //Crea y configura el contenedor de modelo compartido para datos persistentes
    private static func createModelContainer() -> ModelContainer {
        let schema = Schema([
            CryptoCurrency.self,
        ])
        
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("No se pudo crear el contenedor de modelo: \(error)")
        }
    }
}
