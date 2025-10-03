//
//  APIService.swift
//  lobo1
//
//  Created by alumno on 16/1/25.
//


import Foundation

class APIService {
    
    
    
    private static let apiKey = Secrets.apiKey
    
    private static let baseURL = "https://api.coingecko.com/api/v3/"

    
    //conseguir informacion a cerca de las monedas mas populares
    public static func getPopularCoins(completion: @escaping (Result<[CryptoCurrency], Error>) -> Void) {
        let urlString = baseURL + "coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false&" + apiKey
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data not received"])))
                return
            }
            
            //Decodificacion de los datos
            do {
                let decoder = JSONDecoder()
                // Decodifica la respuesta en una lista de criptomonedas
                let coinsArray = try decoder.decode([PopularCoin].self, from: data)
                
                //Los objetos CoinGecko se transforman en CryptoCurrency
                let coins = coinsArray.map { coin in
                    CryptoCurrency(name: coin.name, APIid: coin.id, symbol: coin.symbol)
                }
                completion(.success(coins))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    //buscar monedas por texto ingresado
    public static func searchCoins(query: String, completion: @escaping (Result<[CryptoCurrency], Error>) -> Void) {
        let urlString = baseURL + "search?query=\(query)&" + apiKey
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data not received"])))
                return
            }
            
            //Decodificacion de los datos
            do {
                let decoder = JSONDecoder()
                let searchResult = try decoder.decode(SearchResult.self, from: data)
                let coins = searchResult.coins.map { coin in
                    CryptoCurrency(name: coin.name, APIid: coin.id, symbol: coin.symbol)
                }
                completion(.success(coins))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    
    
    // DETALLES DE LA MONEDA SELECCIONADA
    public static func getDetails(coinId: String, completion: @escaping (Result<CoinDataMarket, Error>) -> Void) {
        let urlString = baseURL + "coins/" + coinId + "?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false&" + apiKey
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data not received"])))
                return
            }
             //Decodificacion de los datos
            do {
                let jsonDecoder = JSONDecoder()
                //Convierte los datos en un objeto CoinData
                let decodedData = try jsonDecoder.decode(CoinDataMarket.self, from: data)
                completion(.success(decodedData))
            } catch {
                print("Decoding Error: \(error)")
                completion(.failure(error))
            }
        }
    
        task.resume()
    }
    
    // PRECIOS HISTORICOS DESDE X DIAS
    public static func getHistoricalPrices(coinId: String, currency: String, days: Int, completion: @escaping (Result<[Price], Error>) -> Void) {
        
        
        //el valor de days que se pasa como parametro sirve para buscar los precios de los ultimos x days
        var components = URLComponents(string: baseURL + "coins/\(coinId)/market_chart")!
        components.queryItems = [
            URLQueryItem(name: "vs_currency", value: currency),
            URLQueryItem(name: "days", value: String(days)),
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        guard let url = components.url else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data not received"])))
                return
            }
            
            //Lo guardamos en prices que es un array de arrays, cada subarray correndesponde a timestampo, value.
            do {
                let decodedData = try JSONDecoder().decode(HistoricalPrices.self, from: data)
                let prices = decodedData.prices.map { array in
                    Price(timestamp: Int(array[0]), value: array[1])
                }
                completion(.success(prices))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    
 }

// Estructuras para guardar los datos de la API
struct PopularCoin: Codable {
    
    let id: String
    let symbol: String
    let name: String
}

struct HistoricalPrices: Decodable {
    let prices: [[Double]]
}

struct Price: Decodable {
    let timestamp: Int
    let value: Double
}



// Struct para decodificar los resultados de búsqueda
struct SearchResult: Codable {
    let coins: [SearchCoin] //clave coins
}

struct SearchCoin: Codable {
    let id: String
    let name: String
    let symbol: String
}



struct CoinDataMarket: Codable {
    let image: ImageURLs
    let description: [String: String]
    let market_data: MarketDetails
}

struct ImageURLs: Codable {
    let thumb: String?
    let small: String?
    let large: String?
}

struct MarketDetails: Codable {  //Para los detalles economicos
    let current_price: [String: Double]
    let market_cap_rank: Int?
    let total_volume: [String: Double]?

}

