import Foundation
import Combine

final class RootViewModel: StoreViewModel {
    @Published var showSplash = true
    private var bag = Set<AnyCancellable>()

    override init(store: AppStore = .shared) {
        super.init(store: store)
        // Logging out sends the user back to the welcome screen.
        store.$hasSeenOnboarding
            .dropFirst()
            .filter { !$0 }
            .sink { [weak self] _ in self?.showSplash = true }
            .store(in: &bag)
    }

    var hasSeenOnboarding: Bool { store.hasSeenOnboarding }

    func finishSplash() { showSplash = false }
    func finishOnboarding() { store.hasSeenOnboarding = true }
}
