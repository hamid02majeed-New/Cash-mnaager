import Foundation

struct Currency: Identifiable, Hashable {
    let code: String
    let symbol: String
    let name: String

    var id: String { code }
    var label: String { "\(code) (\(symbol))" }

    func format(_ value: Double) -> String {
        "\(symbol) \(Formatters.number(value))"
    }

    func signed(_ value: Double, kind: TransactionKind) -> String {
        (kind == .income ? "+ " : "- ") + format(value)
    }

    static let all: [Currency] = [
        Currency(code: "PKR", symbol: "Rs.", name: "Pakistani Rupee"),
        Currency(code: "USD", symbol: "$", name: "US Dollar"),
        Currency(code: "EUR", symbol: "€", name: "Euro"),
        Currency(code: "GBP", symbol: "£", name: "British Pound"),
        Currency(code: "INR", symbol: "₹", name: "Indian Rupee"),
        Currency(code: "AED", symbol: "AED", name: "UAE Dirham"),
        Currency(code: "SAR", symbol: "SAR", name: "Saudi Riyal")
    ]

    static func with(code: String) -> Currency {
        all.first { $0.code == code } ?? all[0]
    }
}
