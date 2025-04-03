//
//  NetworkManager.swift
//  StockMarketCombine
//
//  Created by Rashad Milton on 3/5/25.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    func fetchStock(symbol: String) -> AnyPublisher<Stock?, Error>
}
struct NetworkData{
    static let apiKey = "L11LLVCPA1YJHTZP"
    static let url = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol="
}
// MARK: - NetworkManager
class NetworkManager: NetworkManagerProtocol {
    
    func fetchStock(symbol: String) -> AnyPublisher<Stock?, Error> {
        guard let url = URL(string: NetworkData.url + "\(symbol)&apikey=\(NetworkData.apiKey)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: StockResponse.self, decoder: JSONDecoder())
            .map { $0.stock }
            .eraseToAnyPublisher()
    }
}
