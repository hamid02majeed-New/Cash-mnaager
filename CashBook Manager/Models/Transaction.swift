import Foundation

struct Transaction: Identifiable, Codable, Hashable {
    var id = UUID()
    var kind: TransactionKind
    var categoryID: String
    var amount: Double
    var date: Date
    var note: String = ""

    var category: Category { Category.with(id: categoryID) }
}
