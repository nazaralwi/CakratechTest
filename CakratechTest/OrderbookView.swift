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
    @State private var showOrderConfirm = false
    @State private var toastMessage: String? = nil

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

                        // Buy / Sell Tabs
                        BuySellTabs(vm: vm)

                        // Order Form
                        OrderForm(vm: vm, showConfirm: $showOrderConfirm)

                        Spacer(minLength: 40)
                    }
                }

                if let msg = toastMessage {
                    VStack {
                        Spacer()
                        Text(msg)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.black.opacity(0.8))
                            .clipShape(Capsule())
                            .padding(.bottom, 100)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
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
        .sheet(isPresented: $showOrderConfirm) {
            OrderConfirmSheet(vm: vm, isPresented: $showOrderConfirm) { message in
                withAnimation {
                    toastMessage = message
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation { toastMessage = nil }
                }
            }
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

struct BuySellTabs: View {
    @ObservedObject var vm: OrderbookViewModel

    var body: some View {
        HStack(spacing: 0) {
            ForEach(["buy", "sell"], id: \.self) { tab in
                Button {
                    vm.selectedTab = tab
                } label: {
                    VStack(spacing: 4) {
                        Text(tab.capitalized)
                            .font(.system(size: 15, weight: vm.selectedTab == tab ? .semibold : .regular))
                            .foregroundStyle(vm.selectedTab == tab ? .primary : .secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)

                        Rectangle()
                            .fill(vm.selectedTab == tab ? .blue : .clear)
                            .frame(height: 2)
                    }
                }
            }
        }
        .background(
            VStack {
                Spacer()
                Divider()
            }
        )
    }
}

struct OrderForm: View {
    @ObservedObject var vm: OrderbookViewModel
    @Binding var showConfirm: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Available Cash + Buying Limit
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Available Cash")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    Text("Rp\(formatCurrency(vm.availableCash))")
                        .font(.system(size: 14, weight: .semibold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Buying Limit")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    Text("Rp\(formatCurrency(vm.buyingLimit))")
                        .font(.system(size: 14, weight: .semibold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 14)

            Divider().padding(.horizontal, 16)

            // Order Type
            FormRow(label: "Order Type") {
                DropdownPicker(selection: $vm.orderType, options: vm.orderTypes)
            }

            Divider().padding(.horizontal, 16)

            // Buy/Sell Price
            FormRow(label: vm.selectedTab == "buy" ? "Buy Price" : "Sell Price") {
                StepperField(value: $vm.orderPrice, onDecrement: vm.decrementPrice, onIncrement: vm.incrementPrice)
            }

            Divider().padding(.horizontal, 16)

            // Lot Quantity
            FormRow(label: "Lot Quantity") {
                StepperField(value: $vm.lotQuantity, onDecrement: vm.decrementLot, onIncrement: vm.incrementLot)
            }

            // Total value hint
            if vm.lotQuantity > 0 {
                HStack {
                    Spacer()
                    Text("Total: Rp\(formatCurrency(vm.totalValue))")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .padding(.trailing, 16)
                        .padding(.top, 2)
                }
            }

            // Max Cash / Max Limit
            HStack(spacing: 10) {
                Button {
                    vm.setMaxCash()
                } label: {
                    Text("Max Cash")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }

                Button {
                    vm.setMaxLimit()
                } label: {
                    Text("Max Limit")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            Divider().padding(.horizontal, 16).padding(.top, 14)

            // Board
            FormRow(label: "Board") {
                DropdownPicker(selection: $vm.board, options: vm.boards)
            }

            Divider().padding(.horizontal, 16)

            // Stop Loss / Take Profit
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text("Stop Loss / Take Profit")
                            .font(.system(size: 14))
                        Image(systemName: "info.circle")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    Text("Set up conditions for your stock right away.")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Toggle("", isOn: $vm.stopLossEnabled)
                    .labelsHidden()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            Divider().padding(.horizontal, 16)

            // Buy / Sell Button
            Button {
                showConfirm = true
            } label: {
                Text(vm.selectedTab == "buy" ? "Buy" : "Sell")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(vm.selectedTab == "buy" ? Color.blue : Color.red)
                    .cornerRadius(12)
                    .opacity(vm.lotQuantity == 0 ? 0.5 : 1.0)
            }
            .disabled(vm.lotQuantity == 0)
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 8)
        }
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value))"
    }
}

struct FormRow<Content: View>: View {
    let label: String
    let content: () -> Content

    init(label: String, @ViewBuilder content: @escaping () -> Content) {
        self.label = label
        self.content = content
    }

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
            Spacer()
            content()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct StepperField: View {
    @Binding var value: Int
    let onDecrement: () -> Void
    let onIncrement: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Button(action: onDecrement) {
                Image(systemName: "minus")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.blue)
                    .frame(width: 28, height: 28)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }

            Text("\(value)")
                .font(.system(size: 15, weight: .medium, design: .monospaced))
                .frame(minWidth: 50, alignment: .center)

            Button(action: onIncrement) {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.blue)
                    .frame(width: 28, height: 28)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }
        }
    }
}

struct DropdownPicker: View {
    @Binding var selection: String
    let options: [String]
    @State private var showPicker = false

    var body: some View {
        Button {
            showPicker = true
        } label: {
            HStack(spacing: 4) {
                Text(selection)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                Image(systemName: "chevron.down")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
        }
        .confirmationDialog("Select", isPresented: $showPicker) {
            ForEach(options, id: \.self) { option in
                Button(option) { selection = option }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#Preview {
    OrderbookView()
}
