import Foundation

final class HomeViewModel: StoreViewModel {
    var balanceText: String { money(store.balance) }
    var incomeText: String { money(store.totalIncome) }
    var expenseText: String { money(store.totalExpense) }

    var recent: [Transaction] {
        Array(store.transactions.sorted { $0.date > $1.date }.prefix(4))
    }
}
