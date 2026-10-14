import Combine
import Foundation

final class AccountViewModel: StoreViewModel {
    @Published var name: String
    @Published var email: String
    @Published var justSaved = false

    override init(store: AppStore = .shared) {
        name = store.userName
        email = store.userEmail
        super.init(store: store)
    }

    func save() {
        store.userName = name.trimmingCharacters(in: .whitespaces)
        store.userEmail = email.trimmingCharacters(in: .whitespaces)
        justSaved = true
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            justSaved = false
        }
    }
}
