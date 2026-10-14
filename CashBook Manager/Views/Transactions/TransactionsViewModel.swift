import Combine
import Foundation

struct TransactionSection: Identifiable {
    let id: String
    let title: String
    let items: [Transaction]
}

enum TransactionFilter: String, CaseIterable, Identifiable {
    case all = "All", income = "Income", expense = "Expense"
    var id: String { rawValue }
}

enum TransactionSort: String, CaseIterable, Identifiable {
    case newest = "Newest first"
    case oldest = "Oldest first"
    case highest = "Highest amount"
    case lowest = "Lowest amount"
    var id: String { rawValue }
}

final class TransactionsViewModel: StoreViewModel {
    @Published var searchText = ""
    @Published var filter: TransactionFilter = .all
    @Published var sort: TransactionSort = .newest

    var sections: [TransactionSection] {
        var list = store.transactions

        switch filter {
        case .all: break
        case .income: list = list.filter { $0.kind == .income }
        case .expense: list = list.filter { $0.kind == .expense }
        }

        let q = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        if !q.isEmpty {
            list = list.filter {
                $0.category.name.lowercased().contains(q)
                    || $0.note.lowercased().contains(q)
                    || Formatters.number($0.amount).contains(q)
            }
        }

        let cal = Calendar.current
        let grouped = Dictionary(grouping: list) { cal.dateComponents([.year, .month], from: $0.date) }
        let ascendingGroups = sort == .oldest
        let keys = grouped.keys
            .compactMap { key in cal.date(from: key).map { (key, $0) } }
            .sorted { ascendingGroups ? $0.1 < $1.1 : $0.1 > $1.1 }

        return keys.map { key, monthDate in
            let items = (grouped[key] ?? []).sorted { a, b in
                switch sort {
                case .newest: return a.date > b.date
                case .oldest: return a.date < b.date
                case .highest: return a.amount > b.amount
                case .lowest: return a.amount < b.amount
                }
            }
            let title = Formatters.monthYear.string(from: monthDate)
            return TransactionSection(id: title, title: title, items: items)
        }
    }

    func delete(_ transaction: Transaction) { store.delete(id: transaction.id) }
}
