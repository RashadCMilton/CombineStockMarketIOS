//
//  StockViewModel.swift
//  StockMarketCombine
//
//  Created by Rashad Milton on 3/5/25.
//
import Foundation
import Combine

// MARK: - ViewModel
// This ViewModel handles fetching stock data from a local JSON file (tickers.json)
// and then fetching the corresponding stock details from an API using Combine.
class StockViewModel: ObservableObject {
    
    // Published properties: These are bound to the UI. When they change, the UI is automatically updated.
    @Published var stocks: [Stock] = [] // Holds the list of fetched stock data.
    @Published var errorMessage: String? // Holds an error message in case of failure.
    
    private var cancellables = Set<AnyCancellable>() // Holds all Combine cancellables to cancel them when done.
    private let networkManager = NetworkManager() // NetworkManager instance to handle API requests.
    
    // Subjects: Used to handle data flow with Combine.
    // `tickersSubject` holds the list of tickers loaded from JSON.
    // `stockSubject` holds the stock data and publishes it when fetched.
    private let tickersSubject = CurrentValueSubject<[Ticker], Never>([]) // Holds tickers from JSON
    private let stockSubject = PassthroughSubject<[Stock], Never>() // Emits stock data to UI

    
    init() {
        setupBindings() // Set up Combine bindings when the ViewModel is initialized.
        loadTickersFromJSON() // Step 1: Load tickers from JSON file when the ViewModel is initialized.
    }

    // Set up Combine bindings between subjects and the published properties.
    private func setupBindings() {
        // Bind `stockSubject` to the `stocks` published property so when stock data is received, it updates the UI.
        stockSubject
            .assign(to: &$stocks)
        
        // When `tickersSubject` is updated, trigger the stock fetch.
        tickersSubject
            .dropFirst() // Ignore the initial empty state of the `tickersSubject`
            .sink { [weak self] tickers in
                print("✅ Loaded tickers: \(tickers.prefix(10))") // Debugging: prints first 10 tickers
                self?.fetchAllStocks() // Call to fetch stock data once tickers are loaded
            }
            .store(in: &cancellables) // Store the cancellable to cancel later if needed
    }

    /// **Step 1: Load stock tickers from a JSON file**
    public func loadTickersFromJSON() {
        // Get the URL for the `tickers.json` file from the app bundle.
        guard let url = Bundle.main.url(forResource: "tickers", withExtension: "json") else {
            // If the file isn't found, set an error message.
            errorMessage = "JSON file not found"
            return
        }

        // Use Combine to load and decode the JSON file asynchronously.
        Just(url) // Start with the URL.
            .tryMap { try Data(contentsOf: $0) } // Convert the URL to Data.
            .decode(type: [Ticker].self, decoder: JSONDecoder()) // Decode the data into an array of Ticker objects.
            .replaceError(with: []) // If there's an error, replace the error with an empty array.
            .sink(receiveValue: { tickers in
                print("✅ Loaded \(tickers.count) tickers") // Debugging: prints the number of tickers loaded.
                self.tickersSubject.send(tickers) // Send tickers to `tickersSubject`, triggering stock fetch.
            })
            .store(in: &cancellables) // Store the cancellable to cancel the operation later if needed.
    }

    /// **Step 2: Fetch stock data from the API using Combine**
    private func fetchAllStocks() {
        // Get the current list of tickers.
        let tickers = tickersSubject.value
        
        // Check if there are any tickers available to fetch.
        guard !tickers.isEmpty else {
            print("❌ No tickers to fetch!") // Debugging: No tickers available for fetching.
            return
        }

        // Debugging: Print first 5 tickers that will be used to fetch stock data.
        print("📡 Fetching stocks for \(tickers.prefix(5))...")

        // Create a list of publishers to fetch stock data for each ticker.
        let stockPublishers = tickers.prefix(25).map { symbol in // Limit to 30 tickers for testing
            print("📡 Requesting stock data for \(symbol)") // Debugging: print the ticker symbol being requested.
            return networkManager.fetchStock(symbol: symbol.ticker) // Request stock data from the network manager.
                .replaceError(with: nil) // If the request fails, return `nil` instead of error.
                .eraseToAnyPublisher() // Convert the result to a generic publisher.
        }

        // Combine all the stock fetch publishers into a single publisher.
        Publishers.MergeMany(stockPublishers)
            .compactMap { $0 } // Ignore `nil` results, keeping only successful stock responses.
            .collect() // Collect all the successful stock results into a single array.
            .receive(on: DispatchQueue.main) // Ensure the result is received on the main thread (UI thread).
            .sink(receiveValue: { stocks in
                print("✅ Received \(stocks.count) stocks") // Debugging: prints the number of stocks received.
                self.stockSubject.send(stocks) // Send the fetched stock data to the stockSubject.
            })
            .store(in: &cancellables) // Store the cancellable to cancel the operation later if needed.
    }

}
