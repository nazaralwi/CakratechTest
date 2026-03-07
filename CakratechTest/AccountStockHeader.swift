//
//  Untitled.swift
//  CakratechTest
//
//  Created by Macintosh on 07/03/26.
//

import SwiftUI

struct AccountStockHeader: View {
    @ObservedObject var vm: OrderbookViewModel
    @Binding var showStockSearch: Bool

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

                        Button {
                            showStockSearch = true
                        } label: {
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
