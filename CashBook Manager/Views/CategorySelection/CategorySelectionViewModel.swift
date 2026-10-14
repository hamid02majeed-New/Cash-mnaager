import Combine
import Foundation

final class CategorySelectionViewModel: ObservableObject {
    let kind: TransactionKind
    let selectedID: String?
    @Published var query = ""

    init(kind: TransactionKind, selectedID: String?) {
        self.kind = kind
        self.selectedID = selectedID
    }

    var categories: [Category] {
        let all = Category.categories(for: kind)
        let q = query.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty else { return all }
        return all.filter { $0.name.localizedCaseInsensitiveContains(q) }
    }
}
