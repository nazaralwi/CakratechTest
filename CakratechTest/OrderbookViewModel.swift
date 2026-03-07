//
//  Untitled.swift
//  CakratechTest
//
//  Created by Macintosh on 07/03/26.
//

import Combine

class OrderbookViewModel: ObservableObject {
    @Published var selectedStock: Stock = Stock.sampleStocks.first(where: { $0.code == "GOTO" })!
    @Published var orderbookRows: [OrderbookRow] = []
    @Published var showTable: Bool = true
    @Published var selectedTab: String = "buy"

    init() {
        refreshOrderbook()
    }

    func refreshOrderbook() {
        orderbookRows = Stock.generateOrderbook(basePrice: selectedStock.price)
    }

    func selectStock(_ stock: Stock) {
        selectedStock = stock
        refreshOrderbook()
    }

    func sumBidLots() -> Int {
        orderbookRows.compactMap { $0.bidLot }.reduce(0, +)
    }

    func sumAskLots() -> Int {
        orderbookRows.compactMap { $0.askLot }.reduce(0, +)
    }
}
