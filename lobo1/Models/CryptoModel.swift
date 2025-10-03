//
//  CryptoModel.swift
//  lobo1
//
//  Created by alumno on 16/1/25.
//



import Foundation
import SwiftData

class CryptoModel {
    private var popularList: [CryptoCurrency] = []
    var historicalPrices: [Price] = []
    
    
    //Funcion para cargar las monedas mas populares
    public func loadPopularCoins(completion: @escaping () -> Void) {
        // Llama a la API para obtener monedas populares
        APIService.getPopularCoins { result in
            switch result {
            case .success(let coins):
                self.popularList = coins // Almacena las monedas populares directamente en recommended
                completion() // Llama al callback cuando termina
            case .failure(let error):
                print("Error fetching popular coins: \(error)")
                completion() // Llama al callback incluso en caso de error
            }
        }
    }
    
    //Funcion para buscar monedas
    public func searchCoins(query: String, completion: @escaping ([CryptoCurrency]) -> Void) {
        APIService.searchCoins(query: query) { result in
            switch result {
            case .success(let coins):
                completion(coins) // Devuelve las monedas encontradas
            case .failure(let error):
                print("Error searching for coins: \(error)")
                completion([]) // Devuelve una lista vacía en caso de error
            }
        }
    }
    
    public func isEuro() -> Bool {
        return UserDefaults.standard.bool(forKey: "euro")
    }
    
    public func setEuro(euro: Bool) {
        UserDefaults.standard.set(euro, forKey: "euro")
    }
    
    
    public func getPopularList() -> [CryptoCurrency] {
        return popularList
    }
}

