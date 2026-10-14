import SwiftUI

enum TransactionKind: String, Codable, CaseIterable, Identifiable {
    case expense, income

    var id: String { rawValue }
    var title: String { self == .expense ? "Expense" : "Income" }
    var icon: String { self == .expense ? "minus" : "plus" }
}

struct Category: Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String
    let color: Color
    let kind: TransactionKind

    // MARK: Expense categories
    static let food = Category(id: "food", name: "Food & Dining", icon: "fork.knife", color: Color(hex: 0xF0525A), kind: .expense)
    static let transport = Category(id: "transport", name: "Transport", icon: "car.fill", color: Color(hex: 0x2F6BFF), kind: .expense)
    static let groceries = Category(id: "groceries", name: "Groceries", icon: "cart.fill", color: Color(hex: 0xFF8A1F), kind: .expense)
    static let bills = Category(id: "bills", name: "Bills", icon: "doc.text.fill", color: Color(hex: 0x7B61FF), kind: .expense)
    static let shopping = Category(id: "shopping", name: "Shopping", icon: "bag.fill", color: Color(hex: 0xF0407F), kind: .expense)
    static let entertainment = Category(id: "entertainment", name: "Entertainment", icon: "gamecontroller.fill", color: Color(hex: 0xFFB400), kind: .expense)
    static let health = Category(id: "health", name: "Health", icon: "heart.text.square.fill", color: Color(hex: 0x1FAF6B), kind: .expense)
    static let education = Category(id: "education", name: "Education", icon: "graduationcap.fill", color: Color(hex: 0x1AA6A6), kind: .expense)
    static let otherExpense = Category(id: "otherExpense", name: "Other", icon: "ellipsis", color: Color(hex: 0x8E8E93), kind: .expense)

    // MARK: Income categories
    static let salary = Category(id: "salary", name: "Salary", icon: "arrow.up.right", color: Color(hex: 0x1FAF6B), kind: .income)
    static let business = Category(id: "business", name: "Business", icon: "briefcase.fill", color: Color(hex: 0x2F6BFF), kind: .income)
    static let freelance = Category(id: "freelance", name: "Freelance", icon: "laptopcomputer", color: Color(hex: 0x7B61FF), kind: .income)
    static let investment = Category(id: "investment", name: "Investment", icon: "chart.line.uptrend.xyaxis", color: Color(hex: 0xFF8A1F), kind: .income)
    static let gift = Category(id: "gift", name: "Gift", icon: "gift.fill", color: Color(hex: 0xF0407F), kind: .income)
    static let otherIncome = Category(id: "otherIncome", name: "Other", icon: "ellipsis", color: Color(hex: 0x8E8E93), kind: .income)

    static let expenses: [Category] = [food, transport, groceries, bills, shopping, entertainment, health, education, otherExpense]
    static let incomes: [Category] = [salary, business, freelance, investment, gift, otherIncome]
    static let all: [Category] = expenses + incomes

    static func categories(for kind: TransactionKind) -> [Category] {
        kind == .expense ? expenses : incomes
    }

    static func with(id: String) -> Category {
        all.first { $0.id == id } ?? otherExpense
    }
}
