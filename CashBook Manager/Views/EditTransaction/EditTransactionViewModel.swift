import Combine
import Foundation

final class EditTransactionViewModel: StoreViewModel {
    private let original: Transaction?
    let kind: TransactionKind

    @Published var category: Category
    @Published var amountText: String {
        didSet {
            let clean = Formatters.sanitizeAmount(amountText)
            if clean != amountText { amountText = clean }
        }
    }
    @Published var date: Date
    @Published var note: String
    @Published var isPickingCategory = false
    @Published var showDeleteConfirm = false

    init(id: UUID, store: AppStore = .shared) {
        let t = store.transaction(id: id)
        original = t
        kind = t?.kind ?? .expense
        category = t?.category ?? .otherExpense
        amountText = t.map { Formatters.number($0.amount).replacingOccurrences(of: ",", with: "") } ?? ""
        date = t?.date ?? Date()
        note = t?.note ?? ""
        super.init(store: store)
    }

    var exists: Bool { original != nil }
    var amount: Double { Double(amountText) ?? 0 }
    var canSave: Bool { exists && amount > 0 }
    var symbol: String { currency.symbol }

    /// Returns true when saved so the view can dismiss.
    func save() -> Bool {
        guard canSave, var updated = original else { return false }
        updated.categoryID = category.id
        updated.amount = amount
        updated.date = date
        updated.note = note.trimmingCharacters(in: .whitespacesAndNewlines)
        store.update(updated)
        return true
    }

    func delete() {
        guard let original else { return }
        store.delete(id: original.id)
    }
}
