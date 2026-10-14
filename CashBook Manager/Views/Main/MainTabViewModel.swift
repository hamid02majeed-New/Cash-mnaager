import Combine
import Foundation

enum MainTab: Hashable {
    case home, analytics, more
}

final class MainTabViewModel: ObservableObject {
    @Published var selection: MainTab = .home
    @Published var isAddingTransaction = false

    func select(_ tab: MainTab) { selection = tab }
    func addTapped() { isAddingTransaction = true }
}
