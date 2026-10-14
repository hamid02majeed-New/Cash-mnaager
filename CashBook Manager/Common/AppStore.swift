import Foundation
import Combine

/// Single source of truth for the app. Persists to a JSON file in Documents.
final class AppStore: ObservableObject {
    static let shared = AppStore()

    @Published private(set) var transactions: [Transaction] = [] { didSet { save() } }
    @Published var monthlyBudget: Double = 0 { didSet { save() } }
    @Published var currencyCode: String = "PKR" { didSet { save() } }
    @Published var hasSeenOnboarding = false { didSet { save() } }
    @Published var userName = "" { didSet { save() } }
    @Published var userEmail = "" { didSet { save() } }
    @Published var remindersEnabled = false { didSet { save() } }

    var currency: Currency { Currency.with(code: currencyCode) }

    private struct Snapshot: Codable {
        var transactions: [Transaction]
        var monthlyBudget: Double
        var currencyCode: String
        var hasSeenOnboarding: Bool
        var userName: String
        var userEmail: String
        var remindersEnabled: Bool
    }

    private let fileURL: URL

    private init() {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = dir.appendingPathComponent("pocket-data.json")
        load()
    }

    // MARK: Persistence

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let snapshot = try? JSONDecoder().decode(Snapshot.self, from: data) else { return }
        transactions = snapshot.transactions
        monthlyBudget = snapshot.monthlyBudget
        currencyCode = snapshot.currencyCode
        hasSeenOnboarding = snapshot.hasSeenOnboarding
        userName = snapshot.userName
        userEmail = snapshot.userEmail
        remindersEnabled = snapshot.remindersEnabled
    }

    private func save() {
        let snapshot = Snapshot(
            transactions: transactions,
            monthlyBudget: monthlyBudget,
            currencyCode: currencyCode,
            hasSeenOnboarding: hasSeenOnboarding,
            userName: userName,
            userEmail: userEmail,
            remindersEnabled: remindersEnabled
        )
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    // MARK: Mutations

    func add(_ transaction: Transaction) {
        transactions.append(transaction)
    }

    func update(_ transaction: Transaction) {
        guard let index = transactions.firstIndex(where: { $0.id == transaction.id }) else { return }
        transactions[index] = transaction
    }

    func delete(id: UUID) {
        transactions.removeAll { $0.id == id }
    }

    func transaction(id: UUID) -> Transaction? {
        transactions.first { $0.id == id }
    }

    func removeAllTransactions() {
        transactions = []
    }

    func logOut() {
        hasSeenOnboarding = false
    }

    func loadSampleData() {
        let cal = Calendar.current
        func day(_ offset: Int) -> Date { cal.date(byAdding: .day, value: -offset, to: Date()) ?? Date() }
        let samples: [(TransactionKind, Category, Double, Int, String)] = [
            (.expense, .groceries, 2500, 0, "Weekly groceries"),
            (.income, .salary, 50000, 1, "Monthly salary"),
            (.expense, .transport, 300, 1, "Taxi"),
            (.expense, .food, 1200, 2, "Lunch with friends"),
            (.expense, .shopping, 2000, 4, ""),
            (.expense, .food, 5000, 6, "Dinner"),
            (.expense, .transport, 3200, 8, "Fuel"),
            (.expense, .groceries, 300, 9, ""),
            (.expense, .bills, 3000, 10, "Electricity")
        ]
        transactions.append(contentsOf: samples.map {
            Transaction(kind: $0.0, categoryID: $0.1.id, amount: $0.2, date: day($0.3), note: $0.4)
        })
    }

    // MARK: Queries

    func transactions(in interval: DateInterval, kind: TransactionKind? = nil) -> [Transaction] {
        transactions.filter {
            $0.date >= interval.start && $0.date < interval.end && (kind == nil || $0.kind == kind)
        }
    }

    func total(of kind: TransactionKind) -> Double {
        transactions.filter { $0.kind == kind }.reduce(0) { $0 + $1.amount }
    }

    var totalIncome: Double { total(of: .income) }
    var totalExpense: Double { total(of: .expense) }
    var balance: Double { totalIncome - totalExpense }

    var currentMonthSpent: Double {
        guard let interval = Calendar.current.dateInterval(of: .month, for: Date()) else { return 0 }
        return transactions(in: interval, kind: .expense).reduce(0) { $0 + $1.amount }
    }
}

/// Base class for screen view models. Re-publishes store changes so views refresh.
class StoreViewModel: ObservableObject {
    let store: AppStore
    private var cancellable: AnyCancellable?

    init(store: AppStore = .shared) {
        self.store = store
        cancellable = store.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    var currency: Currency { store.currency }

    func money(_ value: Double) -> String { currency.format(value) }
}
