import Combine
import Foundation

final class BudgetViewModel: StoreViewModel {
    @Published var budgetText: String {
        didSet {
            let clean = Formatters.sanitizeAmount(budgetText)
            if clean != budgetText { budgetText = clean }
        }
    }
    @Published var justSaved = false

    override init(store: AppStore = .shared) {
        budgetText = store.monthlyBudget > 0
            ? Formatters.number(store.monthlyBudget).replacingOccurrences(of: ",", with: "") : ""
        super.init(store: store)
    }

    var symbol: String { currency.symbol }
    var budget: Double { store.monthlyBudget }
    var spent: Double { store.currentMonthSpent }
    var remaining: Double { max(budget - spent, 0) }
    var hasBudget: Bool { budget > 0 }
    var isOver: Bool { hasBudget && spent > budget }
    var progress: Double { hasBudget ? min(spent / budget, 1) : 0 }
    var percentText: String { hasBudget ? "\(Int((spent / budget * 100).rounded()))%" : "–" }
    var canSave: Bool { (Double(budgetText) ?? 0) > 0 }

    var footerMessage: String {
        if !hasBudget { return "Set a budget to start tracking." }
        return isOver ? "You're over budget. Time to slow down!" : "Small steps make big goals!"
    }

    func save() {
        guard let value = Double(budgetText), value > 0 else { return }
        store.monthlyBudget = value
        justSaved = true
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            justSaved = false
        }
    }
}
