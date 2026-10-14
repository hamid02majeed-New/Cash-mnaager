import Combine
import Foundation

struct OnboardingPage: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let message: String
}

final class OnboardingViewModel: ObservableObject {
    @Published var index = 0

    let pages: [OnboardingPage] = [
        OnboardingPage(icon: "wallet.bifold.fill", title: "Track Your Expenses",
                       message: "Easily add your income and expenses, and keep your finances under control."),
        OnboardingPage(icon: "target", title: "Set Monthly Budgets",
                       message: "Choose a monthly limit and watch your progress so you never overspend."),
        OnboardingPage(icon: "chart.pie.fill", title: "See Where Money Goes",
                       message: "Colourful charts break down your spending by category, week, month or year.")
    ]

    var isLast: Bool { index == pages.count - 1 }
    var buttonTitle: String { isLast ? "Get Started" : "Next" }

    /// Advances to the next page, or returns true when onboarding is complete.
    func next() -> Bool {
        guard !isLast else { return true }
        index += 1
        return false
    }
}
