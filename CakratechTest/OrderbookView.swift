//
//  ContentView.swift
//  CakratechTest
//
//  Created by Macintosh on 06/03/26.
//

import SwiftUI

struct OrderbookView: View {
    @StateObject private var vm = OrderbookViewModel()
    @State private var showStockSearch = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // AccountStockHeader
                        AccountStockHeader(vm: vm, showStockSearch: $showStockSearch)

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
                            OrderbookTable(vm: vm)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        // Sum Row
                        SumRow(vm: vm)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // Could be move to another screen
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.primary)
                            .fontWeight(.medium)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Could be print or copy something
                    } label: {
                        Image(systemName: "doc.text")
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        .sheet(isPresented: $showStockSearch) {
            StockSearchSheet(vm: vm, isPresented: $showStockSearch)
        }
    }
}

struct SumRow: View {
    @ObservedObject var vm: OrderbookViewModel

    var body: some View {
        HStack {
            Text(lotFormatted(vm.sumBidLots()))
                .font(.system(size: 12, weight: .semibold, design: .monospaced))

            Spacer()

            Text("SUM")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)

            Spacer()

            Text(lotFormatted(vm.sumAskLots()))
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(UIColor.secondarySystemBackground))
    }

    private func lotFormatted(_ n: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: n)) ?? "\(n)"
    }
}

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

#Preview {
    OrderbookView()
}
