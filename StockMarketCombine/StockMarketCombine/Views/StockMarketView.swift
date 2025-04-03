//
//  StockMarketView.swift
//  StockMarketCombine
//
//  Created by Rashad Milton on 3/5/25.
//

//
//  StockMarketView.swift
//  StockMarketCombine
//
//  Created by Rashad Milton on 3/5/25.
//

import SwiftUI

struct StockMarketView: View {
    @StateObject private var viewModel = StockViewModel() // Attach ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                List(viewModel.stocks, id: \.symbol) { stock in
                    StockRowView(stock: stock) // Show stock details in a row
                }
                .listStyle(PlainListStyle()) // Remove default list styling
            }
            .navigationTitle("Stock Market")
            .onAppear {
                viewModel.loadTickersFromJSON() // Load stocks on appear
            }
        }
    }
}

struct StockRowView: View {
    let stock: Stock

    var body: some View {
        HStack {
            Text(stock.symbol)
                .font(.headline)
            Spacer()
            Text(String(format: "$%.2f", stock.price))
                .foregroundColor(.green)
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    StockMarketView()
}
