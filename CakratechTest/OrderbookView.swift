//
//  ContentView.swift
//  CakratechTest
//
//  Created by Macintosh on 06/03/26.
//

import SwiftUI
import Combine

class OrderbookViewModel: ObservableObject {
    @Published var selectedStock: Stock = Stock.sampleStocks.first(where: { $0.code == "GOTO" })!
    @Published var showTable: Bool = true
}

struct OrderbookView: View {
    @StateObject private var vm = OrderbookViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // AccountStockHeader
                        AccountStockHeader(vm: vm)

                        // Orderbook / show table toggle
                        HStack {
                            Button {
                                // Could navigate to orderbook-only view
                            } label: {
                                Text("Orderbook")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 6)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.primary.opacity(0.3), lineWidth: 1)
                                    }
                            }

                            Spacer()

                            Button {
                                // Toggle state show/hide table
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    vm.showTable.toggle()
                                }
                            } label: {
                                Text(vm.showTable ? "Hide Table" : "Show Table")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.blue)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 14)
                        .padding(.bottom, 8)

                        // OrderbookTable
                        if vm.showTable {
                            OrderbookTable()
                        }
                    }
                }
            }
        }
    }
}

struct OrderbookTable: View {
    let orderbookRows: [OrderbookRow] = generateOrderbook(basePrice: 58)

    var body: some View {
        VStack {
            HStack {
                Text("Lot")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Bid")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 50, alignment: .trailing)
                Text("Ask")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 50, alignment: .leading)
                Text("Lot")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 6)

            Divider()

            ForEach(orderbookRows) { row in
                // OrderbookRowView
                OrderbookRowView(row: row)
            }
        }
    }
}

struct OrderbookRowView: View {
    let row: OrderbookRow

    var body: some View {
        HStack(spacing: 0) {
            // Bid lot
            Group {
                if let lot = row.bidLot {
                    Text(lotFormatted(lot))
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.primary)
                } else {
                    Text("")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            // Bid Price
            Group {
                if let price = row.bidPrice {
                    Button {
                        // Could be selected
                    } label: {
                        Text("\(price)")
                            .font(.system(size: 13, weight: .semibold, design: .monospaced))
                            .foregroundStyle(.green)
                            .frame(width: 40, alignment: .trailing)
                    }
                } else {
                    Text("").frame(width: 40)
                }
            }

            // Center divider bar
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 1, height: 18)
                    .padding(.horizontal, 8)
            }
            .frame(width: 18)

            // Ask price
            Group {
                if let price = row.askPrice {
                    Button {
                        // Could be selected
                    } label: {
                        Text("\(price)")
                            .font(.system(size: 13, weight: .semibold, design: .monospaced))
                            .foregroundStyle(.red)
                            .frame(width: 40, alignment: .leading)
                    }
                } else {
                    Text("").frame(width: 40)
                }
            }

            Spacer()

            // Ask lot
            Group {
                if let lot = row.askLot {
                    Text(lotFormatted(lot))
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.primary)
                } else {
                    Text("")
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
        .background(.clear)
    }

    private func lotFormatted(_ n: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: n)) ?? "\(n)"
    }
}

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

struct AccountStockHeader: View {
    @ObservedObject var vm: OrderbookViewModel

    var body: some View {
        VStack(spacing: 0) {
            // AccountRow
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 28, height: 28)

                    Text("MI")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white)
                }
                Text("XMK3 - MUHAMAD FAIZ IDRIS")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 10)

            // Stock row
            HStack(alignment: .center, spacing: 12) {
                // Logo
                StockLogo(code: vm.selectedStock.code, color: vm.selectedStock.logoColor)

                // Name + haircut
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(vm.selectedStock.code)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)

                        // K badge, don't know
                        Text("K")
                            .font(.system(size: 10, weight: .black))
                            .foregroundStyle(.black)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(.yellow)
                            .cornerRadius(3)

                        Button(action: {}) {
                            Image(systemName: "chevron.down")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }

                    Text(vm.selectedStock.name)
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.8))
                        .lineLimit(1)

                    Text("Haircut \(vm.selectedStock.haircutLabel)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white.opacity(0.7))
                }

                Spacer()

                VStack {
                    Text("\(vm.selectedStock.price)")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)

                    let change = vm.selectedStock.change
                    let changePct = vm.selectedStock.changePct
                    let changeStr = change >= 0
                    ? "+\(change) (\(String(format: "%.2f", changePct))%)"
                    : "-\(change) (\(String(format: "%.2f", changePct))%)"

                    Text(changeStr)
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.7))

                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)
        }
        .background(.blue)
    }
}

struct StockLogo: View {
    let code: String
    let color: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: color) ?? .gray)
                .frame(width: 44, height: 44)
            Text(String(code.prefix(2)))
                .font(.system(size: 14, weight: .black))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    OrderbookView()
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized
        guard hexSanitized.count == 6, let hexValue = UInt64(hexSanitized, radix: 16) else { return nil }
        self.init(
            red: Double((hexValue & 0xFF0000) >> 16) / 255,
            green: Double((hexValue & 0x00FF00) >> 8) / 255,
            blue: Double(hexValue & 0x0000FF) / 255
        )
    }
}
