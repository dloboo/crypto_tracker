//
//  CryptoViewModel.swift
//  lobo1
//
//  Created by alumno on 16/1/25.
//


import Foundation

class CryptoViewModel: ObservableObject {
    private let model: CryptoModel
    
    init() {
        self.model = CryptoModel()
    }
    
    public func loadPopularCoins(completion: @escaping () -> Void) {
        model.loadPopularCoins {
            completion()
        }
    }
    
    public func searchCoins(query: String, completion: @escaping ([CryptoCurrency]) -> Void) {
        model.searchCoins(query: query) { coins in
            completion(coins)
        }
    }
    
    public func isEuro() -> Bool {
        return model.isEuro()
    }
    
    public func setEuro(euro: Bool) {
        model.setEuro(euro: euro)
    }
    
    
    func getPopularCoins() -> [CryptoCurrency] {
        return model.getPopularList()
    }
}
