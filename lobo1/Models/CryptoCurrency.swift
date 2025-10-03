//
//  CryptoCurrency.swift
//  lobo1
//
//  Created by alumno on 16/1/25.
//

import Foundation
import SwiftData

@Model
class CryptoCurrency {
    @Attribute var name: String
    @Attribute var APIid: String
    @Attribute var symbol: String
    var coinDescription: String?
    var isFavorite: Bool = false
    var marketRank: Int?
    var volume: [String: Double]?
    var imageURL: URL?
    
    var currentPrice: [String: Double]?
    
    init(name: String, APIid: String, symbol: String) {
        self.name = name
        self.APIid = APIid
        self.symbol = symbol
        
    }

    // ACTUALIZAR DATOS
    func updateDetails() {
        
        APIService.getDetails(coinId: self.APIid) { result in
            switch result {
                case .success (let data):
                DispatchQueue.main.async {
                   
                    self.volume = data.market_data.total_volume
                    self.currentPrice = data.market_data.current_price
                    self.marketRank = data.market_data.market_cap_rank
                    if let urlString = data.image.small {
                        self.imageURL = URL(string: urlString)
                    }
                    self.coinDescription = data.description["en"]
                }
                
                case .failure(let error):
                    print("Error:", error)
            }
        }
    }
    
}
