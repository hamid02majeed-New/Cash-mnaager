import SwiftUI

extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}

enum Theme {
    static let primary = Color(hex: 0x0E8A43)
    static let primaryLight = Color(hex: 0xE3F4EA)
    static let income = Color(hex: 0x0E8A43)
    static let expense = Color(hex: 0xE5484D)
    static let background = Color.white
    static let field = Color(hex: 0xF3F4F6)
    static let border = Color(hex: 0xE5E7EB)
    static let textPrimary = Color(hex: 0x111827)
    static let textSecondary = Color(hex: 0x6B7280)
}
