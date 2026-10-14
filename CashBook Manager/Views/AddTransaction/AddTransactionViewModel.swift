import Combine
import Foundation

final class AddTransactionViewModel: StoreViewModel {
    @Published var kind: TransactionKind = .expense {
        didSet { if category?.kind != kind { category = nil } }
    }
    @Published var amountText = "" {
        didSet {
            let clean = Formatters.sanitizeAmount(amountText)
            if clean != amountText { amountText = clean }
        }
    }
    @Published var category: Category?
    @Published var date = Date()
    @Published var isPickingCategory = false

    var amount: Double { Double(amountText) ?? 0 }
    var canSave: Bool { amount > 0 && category != nil }
    var symbol: String { currency.symbol }

    /// First six categories, with the chosen one swapped in if it came from the full list.
    var gridCategories: [Category] {
        var items = Array(Category.categories(for: kind).prefix(6))
        if let category, !items.contains(category) { items[items.count - 1] = category }
        return items
    }

    func save() {
        guard canSave, let category else { return }
        store.add(Transaction(kind: kind, categoryID: category.id, amount: amount, date: date))
    }
}
