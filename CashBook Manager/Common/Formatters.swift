import Foundation

enum Formatters {
    private static let numberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.locale = Locale(identifier: "en_US")
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 2
        return f
    }()

    private static func dateFormatter(_ format: String) -> DateFormatter {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = format
        return f
    }

    static let shortDate = dateFormatter("MMM d, yyyy")
    static let dayMonth = dateFormatter("MMM d")
    static let monthYear = dateFormatter("MMMM yyyy")
    static let year = dateFormatter("yyyy")

    static func number(_ value: Double) -> String {
        numberFormatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    /// "Today", "Yesterday", "3 days ago" or "Apr 21, 2025".
    static func dateText(_ date: Date, relative: Bool) -> String {
        guard relative else { return shortDate.string(from: date) }
        let cal = Calendar.current
        if cal.isDateInToday(date) { return "Today" }
        if cal.isDateInYesterday(date) { return "Yesterday" }
        let days = cal.dateComponents([.day], from: cal.startOfDay(for: date), to: cal.startOfDay(for: Date())).day ?? 0
        if days > 1 && days < 7 { return "\(days) days ago" }
        return shortDate.string(from: date)
    }

    /// Keeps digits and a single decimal point (max 2 decimals).
    static func sanitizeAmount(_ text: String) -> String {
        var result = ""
        var seenDot = false
        var decimals = 0
        for ch in text {
            if ch.isNumber, ch.isASCII {
                if seenDot { guard decimals < 2 else { continue }; decimals += 1 }
                result.append(ch)
            } else if ch == ".", !seenDot {
                seenDot = true
                result.append(ch)
            }
        }
        return result
    }
}
