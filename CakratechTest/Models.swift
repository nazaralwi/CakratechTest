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
    static let sampleStocks: [Stock] = [
        Stock(code: "AADI", name: "Adi Sarana Armada Tbk", price: 1250, change: 25, changePct: 2.04, logoColor: "#3498db", haircutLabel: "50%"),
        Stock(code: "AALI", name: "Astra Agro Lestari Tbk", price: 6800, change: -75, changePct: -1.09, logoColor: "#27ae60", haircutLabel: "25%"),
        Stock(code: "ABBA", name: "Mahaka Media Tbk", price: 108, change: 2, changePct: 1.89, logoColor: "#e74c3c", haircutLabel: "100%"),
        Stock(code: "ABMM", name: "ABM Investama Tbk", price: 2890, change: 0, changePct: 0.0, logoColor: "#9b59b6", haircutLabel: "0%"),
        Stock(code: "ACES", name: "Ace Hardware Indonesia Tbk", price: 895, change: 10, changePct: 1.13, logoColor: "#e67e22", haircutLabel: "50%"),
        Stock(code: "ADHI", name: "Adhi Karya (Persero) Tbk", price: 440, change: -5, changePct: -1.12, logoColor: "#1abc9c", haircutLabel: "25%"),
        Stock(code: "ADRO", name: "Adaro Energy Indonesia Tbk", price: 2550, change: 30, changePct: 1.19, logoColor: "#2c3e50", haircutLabel: "50%"),
        Stock(code: "ANTM", name: "Aneka Tambang Tbk", price: 1545, change: -15, changePct: -0.96, logoColor: "#c0392b", haircutLabel: "25%"),
        Stock(code: "ASII", name: "Astra International Tbk", price: 5050, change: 50, changePct: 1.0, logoColor: "#16a085", haircutLabel: "0%"),
        Stock(code: "BBCA", name: "Bank Central Asia Tbk", price: 9450, change: 100, changePct: 1.07, logoColor: "#2980b9", haircutLabel: "0%"),
        Stock(code: "BBNI", name: "Bank Negara Indonesia Tbk", price: 5675, change: -25, changePct: -0.44, logoColor: "#8e44ad", haircutLabel: "50%"),
        Stock(code: "BBRI", name: "Bank Rakyat Indonesia Tbk", price: 5400, change: 75, changePct: 1.41, logoColor: "#27ae60", haircutLabel: "0%"),
        Stock(code: "BBRIBQCQ5A", name: "BRI Bonds Q5A", price: 1000, change: 0, changePct: 0.0, logoColor: "#27ae60", haircutLabel: "50%"),
        Stock(code: "BBRIBQCU5A", name: "BRI Bonds CU5A", price: 1000, change: 0, changePct: 0.0, logoColor: "#27ae60", haircutLabel: "50%"),
        Stock(code: "BBTN", name: "Bank Tabungan Negara Tbk", price: 1265, change: -10, changePct: -0.78, logoColor: "#f39c12", haircutLabel: "50%"),
        Stock(code: "BMRI", name: "Bank Mandiri (Persero) Tbk", price: 7250, change: 125, changePct: 1.75, logoColor: "#f1c40f", haircutLabel: "0%"),
        Stock(code: "BRIS", name: "Bank Syariah Indonesia Tbk", price: 2760, change: 40, changePct: 1.47, logoColor: "#2ecc71", haircutLabel: "25%"),
        Stock(code: "CPIN", name: "Charoen Pokphand Indonesia Tbk", price: 5100, change: -50, changePct: -0.97, logoColor: "#e74c3c", haircutLabel: "25%"),
        Stock(code: "EXCL", name: "XL Axiata Tbk", price: 1980, change: 20, changePct: 1.02, logoColor: "#3498db", haircutLabel: "50%"),
        Stock(code: "GGRM", name: "Gudang Garam Tbk", price: 19200, change: -200, changePct: -1.03, logoColor: "#8e44ad", haircutLabel: "25%"),
        Stock(code: "GOTO", name: "GoTo Gojek Tokopedia Tbk", price: 58, change: 0, changePct: 0.0, logoColor: "#00AA5B", haircutLabel: "100%"),
        Stock(code: "HMSP", name: "HM Sampoerna Tbk", price: 815, change: 5, changePct: 0.62, logoColor: "#e74c3c", haircutLabel: "25%"),
        Stock(code: "ICBP", name: "Indofood CBP Sukses Makmur Tbk", price: 9875, change: 75, changePct: 0.77, logoColor: "#e74c3c", haircutLabel: "25%"),
        Stock(code: "INDF", name: "Indofood Sukses Makmur Tbk", price: 6975, change: 25, changePct: 0.36, logoColor: "#e74c3c", haircutLabel: "25%"),
        Stock(code: "ISAT", name: "Indosat Tbk", price: 2010, change: -30, changePct: -1.47, logoColor: "#f39c12", haircutLabel: "50%"),
        Stock(code: "JSMR", name: "Jasa Marga (Persero) Tbk", price: 4520, change: 60, changePct: 1.35, logoColor: "#2980b9", haircutLabel: "25%"),
        Stock(code: "KLBF", name: "Kalbe Farma Tbk", price: 1675, change: 15, changePct: 0.90, logoColor: "#27ae60", haircutLabel: "0%"),
        Stock(code: "MDKA", name: "Merdeka Copper Gold Tbk", price: 2300, change: -20, changePct: -0.86, logoColor: "#f39c12", haircutLabel: "50%"),
        Stock(code: "MEDC", name: "Medco Energi Internasional Tbk", price: 1245, change: 10, changePct: 0.81, logoColor: "#e67e22", haircutLabel: "50%"),
        Stock(code: "PGAS", name: "Perusahaan Gas Negara Tbk", price: 1655, change: -5, changePct: -0.30, logoColor: "#3498db", haircutLabel: "50%"),
        Stock(code: "PTBA", name: "Bukit Asam Tbk", price: 3440, change: 40, changePct: 1.18, logoColor: "#2c3e50", haircutLabel: "25%"),
        Stock(code: "SIDO", name: "Industri Jamu dan Farmasi Sido Muncul Tbk", price: 835, change: 10, changePct: 1.21, logoColor: "#27ae60", haircutLabel: "0%"),
        Stock(code: "SMGR", name: "Semen Indonesia (Persero) Tbk", price: 5375, change: -25, changePct: -0.46, logoColor: "#e74c3c", haircutLabel: "25%"),
        Stock(code: "TLKM", name: "Telkom Indonesia (Persero) Tbk", price: 3560, change: 30, changePct: 0.85, logoColor: "#e74c3c", haircutLabel: "0%"),
        Stock(code: "UNTR", name: "United Tractors Tbk", price: 27800, change: 300, changePct: 1.09, logoColor: "#f39c12", haircutLabel: "25%"),
        Stock(code: "UNVR", name: "Unilever Indonesia Tbk", price: 2510, change: -20, changePct: -0.79, logoColor: "#1abc9c", haircutLabel: "0%"),
    ]

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
