//
//  ContentView.swift
//  lobo
//
//  Created by alumno on 10/1/25.
//


import SwiftUI
import SwiftData
struct ContentView: View {
    @ObservedObject var viewModel: CryptoViewModel

    var body: some View {
        NavigationView {
            //llamamos a una vista que gestiona las pestañas de la app, con acceso al viewModel
            TabBarView(viewModel: viewModel)
        }
    }
}

struct TabBarView: View {
    @ObservedObject var viewModel: CryptoViewModel

    var body: some View {
        TabView {
            
            TabContent(view: ExploreView(viewModel: viewModel), label: "Buscar", icon: "magnifyingglass")
            TabContent(view: HomeView(viewModel: viewModel), label: "Mi contenido", icon: "house")
            TabContent(view: SettingsView(viewModel: viewModel), label: "Settings", icon: "gearshape")
        }
        .tint(.green)
    }

    @ViewBuilder
    private func TabContent<Content: View>(view: Content, label: String, icon: String) -> some View {
        view
            .tabItem {
                Label(label, systemImage: icon)
            }
    }
}


struct ExploreView: View {
    @ObservedObject var viewModel: CryptoViewModel

    var body: some View {
        VStack {
            EncabezadoApp()
            SearchPopularListView(viewModel: viewModel)
        }
        .navigationTitle("Buscar")
    }
}


struct HomeView: View {
    @ObservedObject var viewModel: CryptoViewModel

    var body: some View {
        VStack {
            EncabezadoApp()
            InterestingCryptoListView(viewModel: viewModel)
        }
        .navigationTitle("Mi contenido")
    }
}

struct SettingsView: View {
    @ObservedObject var viewModel: CryptoViewModel

    var body: some View {
        OptionsView(viewModel: viewModel)
            .navigationTitle("Ajustes")
    }
}

