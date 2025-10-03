//
//  PriceFormatter.swift
//  lobo1
//
//  Created by Diego Lobo on 29/1/25.
//



import Foundation

public class PriceFormatter {
    // Función para formatear precios
    public static func formatPrice(value: Double, euro: Bool) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        
        // Definir moneda
        if euro {
            formatter.currencyCode = "EUR"
            formatter.currencySymbol = "€"
        } else {
            formatter.currencyCode = "USD"
            formatter.currencySymbol = "$"
        }
        
        // Definir el número de decimales según el valor
        formatter.maximumFractionDigits = {
            switch value {
            case _ where value > 1_000_000:
                return 0
            case _ where value > 10:
                return 2
            default:
                return 6
            }
        }()
        
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

