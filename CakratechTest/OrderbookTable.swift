//
//  Untitled.swift
//  CakratechTest
//
//  Created by Macintosh on 07/03/26.
//

import SwiftUI

struct OrderbookTable: View {
    @ObservedObject var vm: OrderbookViewModel

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

            ForEach(vm.orderbookRows) { row in
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
