//
//  OrderConfirmSheet.swift
//  CakratechTest
//
//  Created by Macintosh on 07/03/26.
//

import SwiftUI

struct OrderConfirmSheet: View {
    @ObservedObject var vm: OrderbookViewModel
    @Binding var isPresented: Bool
    let onConfirmed: (String) -> Void

    private var isBuy: Bool { vm.selectedTab == "buy" }
    private var actionColor: Color { isBuy ? .blue : .red }
    private var totalValue: Double { Double(vm.lotQuantity) * 100.0 * Double(vm.orderPrice) }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(isBuy ? "Confirm Buy Order" : "Confirm Sell Order")
                            .font(.system(size: 18, weight: .bold))
                        Text(vm.selectedStock.code)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    StockLogo(code: vm.selectedStock.code, color: vm.selectedStock.logoColor)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 20)

                Divider()

                // Order details
                VStack(spacing: 0) {
                    ConfirmRow(label: "Stock", value: "\(vm.selectedStock.code) — \(vm.selectedStock.name)")
                    ConfirmRow(label: "Action", value: isBuy ? "Buy" : "Sell", valueColor: actionColor)
                    ConfirmRow(label: "Order Type", value: vm.orderType)
                    ConfirmRow(label: isBuy ? "Buy Price" : "Sell Price", value: "\(vm.orderPrice)")
                    ConfirmRow(label: "Lot Quantity", value: "\(vm.lotQuantity) lot (\(vm.lotQuantity * 100) shares)")
                    ConfirmRow(label: "Board", value: vm.board)
                    ConfirmRow(label: "Total Value", value: "Rp\(formatCurrency(totalValue))", valueColor: actionColor, bold: true)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Spacer()

                // Warning
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 14))
                    Text("Please verify your order details before confirming.")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)

                // Buttons
                HStack(spacing: 12) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("Cancel")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                    }

                    Button {
                        isPresented = false
                        let msg = isBuy
                            ? "✓ Buy order placed: \(vm.lotQuantity) lot \(vm.selectedStock.code) @ \(vm.orderPrice)"
                            : "✓ Sell order placed: \(vm.lotQuantity) lot \(vm.selectedStock.code) @ \(vm.orderPrice)"
                        onConfirmed(msg)
                    } label: {
                        Text(isBuy ? "Buy" : "Sell")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(actionColor)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            .navigationBarHidden(true)
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))"
    }
}

struct ConfirmRow: View {
    let label: String
    let value: String
    var valueColor: Color = .primary
    var bold: Bool = false

    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .frame(width: 110, alignment: .leading)
            Text(value)
                .font(.system(size: 14, weight: bold ? .semibold : .regular))
                .foregroundColor(valueColor)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 10)
        Divider()
    }
}
