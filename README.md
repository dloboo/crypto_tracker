# 🪙 CryptoTracker

Una aplicación nativa de iOS desarrollada con SwiftUI para el seguimiento en tiempo real de criptomonedas. Permite a los usuarios explorar las criptomonedas más populares, buscar monedas específicas, agregar favoritos y visualizar información detallada de mercado.

## 📱 Características

- **Exploración de Criptomonedas**: Visualiza las 10 criptomonedas más populares ordenadas por capitalización de mercado
- **Búsqueda en Tiempo Real**: Busca cualquier criptomoneda disponible en CoinGecko
- **Gestión de Favoritos**: Marca y guarda tus criptomonedas favoritas para acceso rápido
- **Información Detallada**: Consulta precios actuales, ranking de mercado, volumen y descripción de cada moneda
- **Conversión de Divisas**: Alterna entre USD y EUR para visualizar precios
- **Persistencia de Datos**: Utiliza SwiftData para almacenar favoritos localmente
- **Interfaz Intuitiva**: Navegación por pestañas con diseño moderno y limpio

## 🏗️ Estructura del Proyecto

```
lobo1/
├── CryptoTrackerApp.swift          # Punto de entrada de la aplicación
├── ContentView.swift                # Vista principal con navegación por pestañas
├── Secrets.swift                    # Configuración de API Key
├── EuroToggle.swift                 # Componente para cambiar divisa
├── InterestingButton.swift          # Botón para agregar favoritos
├── PriceFormatter.swift             # Utilidad para formatear precios
│
├── Models/                          # Capa de Modelo (Datos)
│   ├── CryptoCurrency.swift         # Modelo principal de criptomoneda
│   └── CryptoModel.swift            # Lógica de negocio del modelo
│
├── ViewModels/                      # Capa de ViewModel (MVVM)
│   └── CryptoViewModel.swift        # Lógica de presentación
│
├── Services/                        # Capa de Servicios
│   └── APIService.swift             # Comunicación con API de CoinGecko
│
├── Views/                           # Capa de Vista (UI)
│   ├── EncabezadoApp.swift          # Componente de encabezado
│   ├── OptionsView.swift            # Vista de configuración
│   │
│   ├── InterestingList/             # Módulo de Favoritos
│   │   ├── InterestingCryptoListView.swift    # Lista de favoritos
│   │   ├── InterestingCryptoRowView.swift     # Fila de favorito
│   │   └── CryptoDetailView.swift             # Vista de detalle
│   │
│   └── SearchPopularList/           # Módulo de Búsqueda
│       ├── SearchPopularListView.swift        # Vista de búsqueda y populares
│       └── SearchPopularRowView.swift         # Fila de resultado
│
└── Assets.xcassets/                 # Recursos visuales
```

## 🎨 Arquitectura

El proyecto sigue el patrón **MVVM (Model-View-ViewModel)** con una clara separación de responsabilidades:

### **Model (Modelo)**
- `CryptoCurrency`: Entidad principal decorada con `@Model` de SwiftData
- `CryptoModel`: Maneja la lógica de negocio y gestión de datos

### **ViewModel**
- `CryptoViewModel`: Actúa como intermediario entre la vista y el modelo
- Implementa `ObservableObject` para actualización reactiva de la UI

### **View (Vista)**
- Componentes SwiftUI modulares y reutilizables
- Organización por funcionalidades (Búsqueda, Favoritos, Configuración)

### **Services (Servicios)**
- `APIService`: Maneja todas las llamadas HTTP a la API de CoinGecko
- Implementa manejo de errores y decodificación JSON

## 🛠️ Tecnologías Utilizadas

### **Frameworks y Librerías**
- **SwiftUI**: Framework moderno de UI declarativa de Apple
- **SwiftData**: Framework de persistencia de datos (iOS 17+)
- **Foundation**: Framework base de Swift
- **Combine**: Para programación reactiva (implícito en SwiftUI)

### **APIs Externas**
- **CoinGecko API**: Proveedor de datos de criptomonedas en tiempo real
  - Endpoint de mercados: `/coins/markets`
  - Endpoint de búsqueda: `/search`
  - Endpoint de detalles: `/coins/{id}`

### **Patrones y Principios**
- **MVVM**: Separación clara de lógica y presentación
- **Dependency Injection**: El ViewModel se inyecta en las vistas
- **Async/Await**: Manejo asíncrono de red (compatible con callbacks)
- **Model Container**: Gestión centralizada de persistencia

## 📋 Requisitos Previos

- **macOS**: Ventura (13.0) o superior
- **Xcode**: 15.0 o superior
- **iOS**: Dispositivo o simulador con iOS 17.0 o superior
- **Cuenta de CoinGecko**: API Key gratuita ([obtener aquí](https://www.coingecko.com/en/api))

## 🚀 Instalación y Configuración

### 1. Clonar el Repositorio

```bash
git clone https://github.com/dloboo/crypto_tracker.git
cd CryptoTrackerDiegoLobo
```

### 2. Configurar la API Key

1. Crea un archivo `Secrets.swift` en la carpeta `lobo1/` si no existe:

```bash
touch lobo1/Secrets.swift
```

2. Añade tu API Key de CoinGecko:

```swift
//
//  Secrets.swift
//  lobo1
//

import Foundation

struct Secrets {
    static let apiKey = "x_cg_demo_api_key=TU_API_KEY_AQUI"
}
```

3. Reemplaza `TU_API_KEY_AQUI` con tu clave real de CoinGecko

> ⚠️ **Importante**: Nunca subas el archivo `Secrets.swift` al repositorio. Añádelo a tu `.gitignore`.

### 3. Abrir el Proyecto

```bash
open lobo1.xcodeproj
```

### 4. Configurar el Proyecto en Xcode

1. Selecciona el proyecto `lobo1` en el navegador
2. En la sección **Signing & Capabilities**:
   - Selecciona tu equipo de desarrollo
   - Verifica que el Bundle Identifier sea único
3. Selecciona un simulador o dispositivo de destino (iOS 17.0+)

### 5. Compilar y Ejecutar

**Desde Xcode**:
- Presiona `⌘ + R` o haz clic en el botón ▶️ Play

**Desde Terminal**:
```bash
xcodebuild -scheme lobo1 -destination 'platform=iOS Simulator,name=iPhone 15' build
```

## 📱 Uso de la Aplicación

### Pestaña "Buscar"
1. Visualiza las 10 criptomonedas más populares por defecto
2. Usa la barra de búsqueda para encontrar monedas específicas
3. Toca cualquier resultado para ver información detallada
4. Presiona el botón "+" para agregar a favoritos

### Pestaña "Mi Contenido"
1. Accede a todas tus criptomonedas marcadas como favoritas
2. Desliza a la izquierda para eliminar de favoritos
3. Los datos se mantienen entre sesiones gracias a SwiftData

### Pestaña "Settings"
1. Alterna entre USD y EUR para mostrar precios
2. La preferencia se guarda en UserDefaults

## 🧪 Testing

El proyecto incluye dos suites de pruebas:

### Pruebas Unitarias
```bash
xcodebuild test -scheme lobo1 -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Pruebas de UI
Ejecuta `lobo1UITests` desde Xcode para validar flujos de usuario completos.

## 📂 Archivos Clave

| Archivo | Descripción |
|---------|-------------|
| `CryptoTrackerApp.swift` | Punto de entrada, configuración de SwiftData |
| `CryptoCurrency.swift` | Modelo de datos principal con `@Model` |
| `APIService.swift` | Cliente HTTP para CoinGecko API |
| `CryptoViewModel.swift` | Lógica de presentación y estado |
| `ContentView.swift` | Estructura de navegación principal |
| `InterestingCryptoListView.swift` | Lista de favoritos con SwiftData Query |
| `SearchPopularListView.swift` | Búsqueda y monedas populares |
| `CryptoDetailView.swift` | Vista detallada de cada criptomoneda |

## 🔧 Configuración Adicional

### Permisos (Entitlements)
El archivo `lobo1.entitlements` puede requerir configuraciones adicionales para funcionalidades futuras como:
- App Groups (para compartir datos)
- Keychain Sharing (para almacenamiento seguro)

### Dependencias Externas
Actualmente, el proyecto **no utiliza dependencias externas** (no hay Swift Package Manager ni CocoaPods), lo que simplifica la configuración.

## 🚧 Mejoras Futuras

### Funcionalidades
- [ ] **Gráficos de Precio**: Integrar gráficos históricos con Charts (iOS 16+)
- [ ] **Notificaciones Push**: Alertas de cambios de precio significativos
- [ ] **Portafolio**: Seguimiento de inversiones con cálculo de ganancias/pérdidas
- [ ] **Modo Offline**: Caché de datos para visualización sin conexión
- [ ] **Widgets**: Visualización de precios en la pantalla de inicio
- [ ] **Compartir**: Opción para compartir criptomonedas en redes sociales
- [ ] **Temas**: Modo oscuro/claro personalizable
- [ ] **Más Divisas**: Soporte para más monedas fiat (GBP, JPY, etc.)

### Mejoras Técnicas
- [ ] **Async/Await Completo**: Migrar callbacks a async/await moderno
- [ ] **Arquitectura**: Considerar Clean Architecture o TCA (The Composable Architecture)
- [ ] **Testing**: Aumentar cobertura de pruebas unitarias y de integración
- [ ] **CI/CD**: Implementar GitHub Actions para pruebas automáticas
- [ ] **Localización**: Soporte multi-idioma (i18n)
- [ ] **Accesibilidad**: Mejorar VoiceOver y Dynamic Type
- [ ] **Manejo de Errores**: UI más robusta para errores de red
- [ ] **Rate Limiting**: Implementar caché inteligente para respetar límites de API
- [ ] **Paginación**: Cargar más resultados al hacer scroll
- [ ] **Imágenes**: Caché de imágenes con AsyncImage mejorado

### Rendimiento
- [ ] **Lazy Loading**: Cargar detalles solo cuando sea necesario
- [ ] **Optimización de SwiftData**: Índices y consultas optimizadas
- [ ] **Memory Management**: Perfiles de uso de memoria con Instruments
- [ ] **Background Refresh**: Actualización de datos en segundo plano

## 🐛 Problemas Conocidos

- La API de CoinGecko tiene límites de rate (10-50 llamadas/minuto en plan gratuito)
- SwiftData requiere iOS 17.0+, limitando compatibilidad con dispositivos antiguos
- Las imágenes de criptomonedas pueden tardar en cargar sin caché implementado

## 📄 Licencia

Este proyecto está bajo la licencia especificada en el archivo `LICENSE`.

## 👨‍💻 Autor

**Diego Lobo**
- GitHub: [@dloboo](https://github.com/dloboo)
- Proyecto: Trabajo Final - Aplicaciones Avanzadas

## 🙏 Agradecimientos

- [CoinGecko](https://www.coingecko.com/) por proporcionar la API de datos de criptomonedas
- Apple por SwiftUI y SwiftData
- Comunidad de Swift por recursos y documentación

## 📞 Soporte

Si encuentras algún problema o tienes sugerencias:
1. Abre un [Issue](https://github.com/dloboo/crypto_tracker/issues) en GitHub
2. Describe el problema con el mayor detalle posible
3. Incluye capturas de pantalla si es aplicable

---

**Desarrollado con ❤️ usando SwiftUI**
