import Combine
import Foundation

struct FAQ: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

final class HelpSupportViewModel: ObservableObject {
    let faqs: [FAQ] = [
        FAQ(question: "How do I add a transaction?",
            answer: "Tap Add in the bottom bar, choose Expense or Income, enter the amount, pick a category and tap Save."),
        FAQ(question: "How do I edit or delete a transaction?",
            answer: "Tap any transaction to edit it. You can also swipe left on a row in the Transactions list to delete it."),
        FAQ(question: "How does the monthly budget work?",
            answer: "Set a limit under Settings > Budget. Pocket compares it with what you've spent this month."),
        FAQ(question: "Where is my data stored?",
            answer: "Only on your device. You can export it as CSV from Data & Privacy.")
    ]

    let supportURL = URL(string: "mailto:support@example.com")!
}
