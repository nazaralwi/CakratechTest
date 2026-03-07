//
//  Untitled.swift
//  CakratechTest
//
//  Created by Macintosh on 07/03/26.
//

import SwiftUI

struct StockSearchSheet: View {
    @ObservedObject var vm: OrderbookViewModel
    @Binding var isPresented: Bool
    @State private var searchQuery = ""
    @State private var selectedTags: [String] = []

    var filteredStocks: [Stock] {
        let q = searchQuery.uppercased()
        if q.isEmpty && selectedTags.isEmpty { return Stock.sampleStocks }
        return Stock.sampleStocks.filter { stock in
            let matchesQuery = q.isEmpty || stock.code.contains(q) || stock.name.uppercased().contains(q)
            return matchesQuery
        }
    }

    var body: some View {
        VStack(spacing: 0) {

            // Search bar
            HStack(spacing: 10) {
                // Tag chips for selected stocks
                if !selectedTags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(selectedTags, id: \.self) { tag in
                                HStack(spacing: 4) {
                                    Text(tag)
                                        .font(.system(size: 13, weight: .medium))
                                    Button {
                                        selectedTags.removeAll { $0 == tag }
                                    } label: {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 10, weight: .bold))
                                    }
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color(UIColor.tertiarySystemFill))
                                .cornerRadius(6)
                            }
                        }
                    }
                    .frame(maxWidth: 200)
                }

                TextField("Search stock code", text: $searchQuery)
                    .textFieldStyle(PlainTextFieldStyle())
                    .autocapitalization(.allCharacters)
                    .disableAutocorrection(true)
                    .font(.system(size: 15))

                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(UIColor.tertiarySystemFill))
            .cornerRadius(10)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)

            // Results list
            List(filteredStocks) { stock in
                Button {
                    vm.selectStock(stock)
                    isPresented = false
                } label: {
                    HStack(spacing: 12) {
                        StockLogo(code: stock.code, color: stock.logoColor)
                            .scaleEffect(0.75)
                            .frame(width: 36, height: 36)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(stock.code)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.primary)
                            Text(stock.name)
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(stock.price)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)

                            let changeStr = stock.change >= 0
                                ? "+\(String(format: "%.2f", stock.changePct))%"
                                : "\(String(format: "%.2f", stock.changePct))%"
                            Text(changeStr)
                                .font(.system(size: 11))
                                .foregroundColor(stock.change > 0 ? .green : stock.change < 0 ? .red : .secondary)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            }
            .listStyle(PlainListStyle())

            // Done button
            HStack {
                TextField("Search stock code", text: $searchQuery)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .disabled(true)

                Spacer()

                Button("Done") {
                    isPresented = false
                }
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.blue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(UIColor.systemBackground))
            .overlay(
                Divider(), alignment: .top
            )
        }
        .background(Color(UIColor.systemBackground))
    }
}
