//
//  Untitled.swift
//  CakratechTest
//
//  Created by Macintosh on 07/03/26.
//

import SwiftUI
import Combine

class OrderbookViewModel: ObservableObject {
    @Published var selectedStock: Stock = Stock.sampleStocks.first(where: { $0.code == "GOTO" })!
    @Published var orderbookRows: [OrderbookRow] = []
    @Published var showTable: Bool = true
    @Published var selectedTab: String = "buy"

    @Published var orderPrice: Int = 58
    @Published var lotQuantity: Int = 0
    @Published var orderType: String = "Limit Order"
    @Published var board: String = "Regular"
    @Published var stopLossEnabled: Bool = false

    let availableCash: Double = 48836
    let orderTypes = ["Limit Order", "Market Order", "Stop Limit"]
    let boards = ["Regular", "Negotiated", "Cash"]

    var buyingLimit: Double { availableCash }
    var totalValue: Double { Double(lotQuantity) * 100.0 * Double(orderPrice) }

    private var tickTimer: AnyCancellable?

    init() {
        refreshOrderbook()
        startTicking()
    }

    func selectStock(_ stock: Stock) {
        selectedStock = stock
        orderPrice = stock.price
        lotQuantity = 0
        refreshOrderbook()
    }

    func refreshOrderbook() {
        orderbookRows = Stock.generateOrderbook(basePrice: selectedStock.price)
    }

    func incrementPrice() {
        orderPrice += fraction(for: orderPrice)
    }

    func decrementPrice() {
        let step = fraction(for: orderPrice)
        orderPrice = max(1, orderPrice - step)
    }

    func incrementLot() { lotQuantity += 1 }
    func decrementLot() { lotQuantity = max(0, lotQuantity - 1) }

    func setMaxCash() {
        guard orderPrice > 0 else { return }
        lotQuantity = Int(availableCash / (Double(orderPrice) * 100.0))
    }

    func setMaxLimit() {
        guard orderPrice > 0 else { return }
        lotQuantity = Int(buyingLimit / (Double(orderPrice) * 100.0))
    }

    // IDX price fraction rules
    private func fraction(for price: Int) -> Int {
        switch price {
        case ..<200: return 1
        case 200..<500: return 2
        case 500..<2000: return 5
        case 2000..<5000: return 10
        default: return 25
        }
    }

    func bidSelected(_ price: Int) {
        orderPrice = price
        selectedTab = "buy"
    }

    func askSelected(_ price: Int) {
        orderPrice = price
        selectedTab = "sell"
    }

    func sumBidLots() -> Int {
        orderbookRows.compactMap { $0.bidLot }.reduce(0, +)
    }

    func sumAskLots() -> Int {
        orderbookRows.compactMap { $0.askLot }.reduce(0, +)
    }

    private func startTicking() {
        tickTimer = Timer.publish(every: 2.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tickOrderbook()
            }
    }

    private func tickOrderbook() {
        orderbookRows = orderbookRows.map { row in
            OrderbookRow(
                bidLot: row.bidLot.map { max(100_000, $0 + Int.random(in: -500_000...500_000)) },
                bidPrice: row.bidPrice,
                askPrice: row.askPrice,
                askLot: row.askLot.map { max(100_000, $0 + Int.random(in: -500_000...500_000)) }
            )
        }
    }
}
