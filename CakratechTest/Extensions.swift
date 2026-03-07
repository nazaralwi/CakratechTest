//
//  Extensions.swift
//  CakratechTest
//
//  Created by Macintosh on 07/03/26.
//

import SwiftUI

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
