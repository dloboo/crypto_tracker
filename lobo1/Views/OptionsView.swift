import SwiftUI

struct OptionsView: View {
    @ObservedObject var viewModel: CryptoViewModel
    @State private var showAlertsView = false
    @State private var useEuro = true

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Configuración General")) {
                    Button(action: {
                        showAlertsView.toggle()
                    }) {
                        HStack {
                            Image(systemName: "bell")
                                .foregroundColor(.blue)
                            Text("Configurar Alarmas")
                        }
                    }
                    .sheet(isPresented: $showAlertsView) {
                        Text("Aquí irá la configuración de alarmas.") // Reemplazar con la vista real de alarmas
                    }
                }

                Section(header: Text("Preferencias de Moneda")) {
                    Toggle(isOn: $useEuro) {
                        Text(useEuro ? "Mostrar en Euros (€)" : "Mostrar en Dólares ($)")
                    }
                    .onChange(of: useEuro) { newValue in
                        viewModel.setEuro(euro: newValue)
                    }
                }

                Section(header: Text("Otra Configuración")) {
                    Text("Opciones adicionales aquí")
                }
            }
            .navigationTitle("Configuración")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: CryptoViewModel())
    }
}

