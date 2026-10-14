import Combine
import Foundation

final class SettingsViewModel: StoreViewModel {
    @Published var showLogoutConfirm = false

    var currencyDetail: String { currency.label }
    var budgetDetail: String { store.monthlyBudget > 0 ? money(store.monthlyBudget) : "Set monthly budget" }
    var accountName: String { store.userName.isEmpty ? "My Account" : store.userName }

    func logOut() { store.logOut() }
}
