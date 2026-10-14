import Combine
import SwiftUI

enum AnalyticsPeriod: String, CaseIterable, Identifiable {
    case week = "Week", month = "Month", year = "Year"
    var id: String { rawValue }

    var component: Calendar.Component {
        switch self {
        case .week: return .weekOfYear
        case .month: return .month
        case .year: return .year
        }
    }
}

struct CategorySlice: Identifiable {
    let id: String
    let name: String
    let color: Color
    let amount: Double
    let percent: Double
}

final class AnalyticsViewModel: StoreViewModel {
    @Published var period: AnalyticsPeriod = .month
    @Published private var anchor = Date()

    private var calendar: Calendar { .current }

    var interval: DateInterval {
        calendar.dateInterval(of: period.component, for: anchor) ?? DateInterval(start: anchor, duration: 86_400)
    }

    var rangeTitle: String {
        let range = interval
        switch period {
        case .week:
            let last = calendar.date(byAdding: .day, value: -1, to: range.end) ?? range.end
            return "\(Formatters.dayMonth.string(from: range.start)) – \(Formatters.dayMonth.string(from: last)), \(Formatters.year.string(from: last))"
        case .month: return Formatters.monthYear.string(from: range.start)
        case .year: return Formatters.year.string(from: range.start)
        }
    }

    var canGoForward: Bool { interval.end <= Date() }

    func step(_ direction: Int) {
        guard direction < 0 || canGoForward else { return }
        anchor = calendar.date(byAdding: period.component, value: direction, to: anchor) ?? anchor
    }

    var totalSpent: Double {
        store.transactions(in: interval, kind: .expense).reduce(0) { $0 + $1.amount }
    }

    /// Top four categories plus an aggregated "Others" slice.
    var slices: [CategorySlice] {
        let expenses = store.transactions(in: interval, kind: .expense)
        let total = expenses.reduce(0) { $0 + $1.amount }
        guard total > 0 else { return [] }

        let sorted = Dictionary(grouping: expenses, by: \.categoryID)
            .map { (category: Category.with(id: $0.key), amount: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.amount > $1.amount }

        var result = sorted.prefix(4).map {
            CategorySlice(id: $0.category.id, name: $0.category.name, color: $0.category.color,
                          amount: $0.amount, percent: $0.amount / total)
        }
        let rest = sorted.dropFirst(4).reduce(0) { $0 + $1.amount }
        if rest > 0 {
            result.append(CategorySlice(id: "others", name: "Others", color: Color(hex: 0xB0B5BD),
                                        amount: rest, percent: rest / total))
        }
        return result
    }
}
