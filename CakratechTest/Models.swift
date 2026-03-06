//
//  Model.swift
//  CakratechTest
//
//  Created by Macintosh on 07/03/26.
//

import Foundation

struct Stock {
    let id = UUID()
    let code: String
    let name: String
    var price: Int
    var change: Int
    var changePct: Double
    let logoColor: String
    let haircutLabel: String
}

struct OrderbookRow: Identifiable {
    let id = UUID()
    let bidLot: Int?
    let bidPrice: Int?
    let askPrice: Int?
    let askLot: Int?
}

extension Stock {
    func generateOrderbook(basePrice: Int) -> [OrderbookRow] {
        var rows: [OrderbookRow] = []

        let bidPrice = (0..<8).map { basePrice - $0 }
        let askPrice = (0..<10).map { basePrice + 1 + $0 }

        for i in 0..<8 {
            rows.append(OrderbookRow(
                bidLot: Int.random(in: 500_000...10_000_000),
                bidPrice: bidPrice[i],
                askPrice: askPrice[i],
                askLot: Int.random(in: 500_000...8_000_000)
            ))
        }

        rows.append(OrderbookRow(bidLot: nil, bidPrice: nil, askPrice: askPrice[8], askLot: Int.random(in: 200_000...3_000_000)))
        rows.append(OrderbookRow(bidLot: nil, bidPrice: nil, askPrice: askPrice[9], askLot: Int.random(in: 200_000...3_000_000)))
        return rows
    }

}
