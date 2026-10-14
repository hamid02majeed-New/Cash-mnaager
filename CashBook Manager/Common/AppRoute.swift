import SwiftUI

enum AppRoute: Hashable {
    case transactions
    case edit(UUID)
    case settings
    case budget
    case account
    case currency
    case notifications
    case privacy
    case help
}

extension View {
    func appDestinations() -> some View {
        navigationDestination(for: AppRoute.self) { route in
            switch route {
            case .transactions: TransactionsView()
            case .edit(let id): EditTransactionView(transactionID: id)
            case .settings: SettingsView(isRoot: false)
            case .budget: BudgetView()
            case .account: AccountView()
            case .currency: CurrencyView()
            case .notifications: NotificationsView()
            case .privacy: DataPrivacyView()
            case .help: HelpSupportView()
            }
        }
    }
}
