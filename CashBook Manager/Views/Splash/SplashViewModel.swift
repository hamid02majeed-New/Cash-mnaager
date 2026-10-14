import Foundation

final class SplashViewModel: StoreViewModel {
    /// First-time users see a "Get Started" button; returning users pass through automatically.
    var showsGetStarted: Bool { !store.hasSeenOnboarding }

    func autoContinueIfNeeded(_ proceed: @escaping () -> Void) {
        guard !showsGetStarted else { return }
        Task {
            try? await Task.sleep(for: .seconds(1.2))
            proceed()
        }
    }
}
