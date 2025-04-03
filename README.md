# StockMarketCombine

An iOS app that displays real-time stock market data using the Alpha Vantage API. The app is written in Swift and uses Combine for reactive programming within an MVVM architecture.

## Project Description

StockMarketCombine fetches stock data for popular tickers and displays their current prices. The app demonstrates the use of Combine framework for handling asynchronous operations and data flow in a clean, declarative way.

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Frameworks](#frameworks)
- [Architecture](#architecture)
- [Design Patterns](#design-patterns)
- [API](#api)

## Features

- Loads stock ticker symbols from a local JSON file
- Fetches real-time stock data from Alpha Vantage API
- Displays stock prices in a clean list interface
- Implements reactive programming using Combine

## Project Structure

The project follows MVVM architecture with clear separation of concerns:

- **Models:** 
  - `Stock.swift` - Data models representing stock information
  
- **Views:** 
  - `StockMarketView.swift` - Main view displaying the list of stocks
  - `StockRowView.swift` - Individual row view for each stock
  
- **ViewModels:** 
  - `StockViewModel.swift` - Handles business logic and data flow between model and view

- **Networking:** 
  - `NetworkManager.swift` - Handles API requests and data parsing

## Installation

- Compatible with iOS 14.0+
- Built with Xcode 13.0+
- No external dependencies required

## Frameworks

- **SwiftUI** - For building the user interface
- **Combine** - For reactive programming and handling asynchronous events
- **Foundation** - For networking and JSON decoding

## Architecture

This application uses MVVM (Model-View-ViewModel) architecture with reactive programming:

- **Model:** Represents the data structure (`Stock`)
- **View:** SwiftUI views displaying the data (`StockMarketView`, `StockRowView`)
- **ViewModel:** Connects the model and view, handling business logic (`StockViewModel`)

## Design Patterns

- **Publisher-Subscriber Pattern** - Used with Combine framework for reactive data flow
- **Protocol-Oriented Programming** - Network layer is built with protocols for easier testing
- **Dependency Injection** - NetworkManager is injected into ViewModel

## API

The app uses the [Alpha Vantage API](https://www.alphavantage.co/) to fetch real-time stock data. 

Sample endpoint:
```
https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=AAPL&apikey=YOUR_API_KEY
```

Response format:
```json
{
  "Global Quote": {
    "01. symbol": "AAPL",
    "05. price": "170.29"
  }
}
```
