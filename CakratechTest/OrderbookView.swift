//
//  ContentView.swift
//  CakratechTest
//
//  Created by Macintosh on 06/03/26.
//

import SwiftUI

struct OrderbookView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // AccountStockHeader
                        AccountStockHeader()

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
                            } label: {
                                Text("Hide Table")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.blue)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 14)
                        .padding(.bottom, 8)
                    }
                }
            }
        }
    }
}

struct AccountStockHeader: View {
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
                StockLogo(code: "GOTO", color: "#00AA5B")

                // Name + haircut
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text("GOTO")
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

                    Text("GoTo Gojek Tokopedia Tbk")
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.8))
                        .lineLimit(1)

                    Text("Haircut 100%")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white.opacity(0.7))
                }

                Spacer()

                VStack {
                    Text("58")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)

                    let change = 0 // refactor
                    let changePct = 0.0 // refactor
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
