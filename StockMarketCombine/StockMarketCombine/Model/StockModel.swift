//
//  StockModel.swift
//  StockMarketCombine
//
//  Created by Rashad Milton on 3/5/25.
//

import Foundation
import Combine
import SwiftUI
// MARK: - Model
struct Stock: Decodable {
    let symbol: String
    let price: Double
}
// MARK: - JSON Extract Model
struct Ticker: Codable {
    let ticker: String
}


struct StockResponse: Decodable {
    let globalQuote: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case globalQuote = "Global Quote"
    }
    
    var stock: Stock? {
        guard let symbol = globalQuote["01. symbol"],
              let priceString = globalQuote["05. price"],
              let price = Double(priceString) else { return nil }
        return Stock(symbol: symbol, price: price)
    }
}
