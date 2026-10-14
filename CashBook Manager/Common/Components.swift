import SwiftUI

// MARK: - Buttons

struct PrimaryButton: View {
    let title: String
    var isEnabled = true
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Theme.primary.opacity(isEnabled ? 1 : 0.4), in: Capsule())
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}

// MARK: - Category badge

struct CategoryBadge: View {
    enum Style { case solid, soft }

    let category: Category
    var size: CGFloat = 44
    var style: Style = .solid

    var body: some View {
        ZStack {
            Circle().fill(style == .solid ? category.color : category.color.opacity(0.16))
            Image(systemName: category.icon)
                .font(.system(size: size * 0.42, weight: .semibold))
                .foregroundStyle(style == .solid ? Color.white : category.color)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Transaction row

struct TransactionRow: View {
    let transaction: Transaction
    let currency: Currency
    var relativeDate = false

    var body: some View {
        HStack(spacing: 12) {
            CategoryBadge(category: transaction.category, size: 44)
            VStack(alignment: .leading, spacing: 3) {
                Text(transaction.category.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Text(Formatters.dateText(transaction.date, relative: relativeDate))
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.textSecondary)
            }
            Spacer()
            Text(currency.signed(transaction.amount, kind: transaction.kind))
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(transaction.kind == .income ? Theme.income : Theme.expense)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

// MARK: - Header

struct ScreenHeader<Trailing: View>: View {
    let title: String
    var showsBack = true
    @ViewBuilder var trailing: () -> Trailing

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
            HStack {
                if showsBack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(Theme.textPrimary)
                            .frame(width: 44, height: 44, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
                trailing()
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 16)
    }
}

extension ScreenHeader where Trailing == EmptyView {
    init(title: String, showsBack: Bool = true) {
        self.init(title: title, showsBack: showsBack) { EmptyView() }
    }
}

// MARK: - Fields

struct SearchField: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Theme.textSecondary)
            TextField(placeholder, text: $text)
                .font(.system(size: 14))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            if !text.isEmpty {
                Button { text = "" } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(Theme.textSecondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 42)
        .background(Theme.field, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct AmountInputField: View {
    enum Style { case filled, outlined }

    @Binding var text: String
    let symbol: String
    var style: Style = .filled

    var body: some View {
        HStack(spacing: 6) {
            Text(symbol)
                .foregroundStyle(text.isEmpty ? Theme.textSecondary.opacity(0.6) : Theme.textPrimary)
            TextField("0", text: $text)
                .keyboardType(.decimalPad)
        }
        .font(.system(size: 22, weight: .semibold))
        .foregroundStyle(Theme.textPrimary)
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(style == .filled ? Theme.field : Color.white, in: RoundedRectangle(cornerRadius: 14))
        .overlay {
            if style == .outlined {
                RoundedRectangle(cornerRadius: 14).stroke(Theme.border, lineWidth: 1)
            }
        }
    }
}

// MARK: - Empty state

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundStyle(Theme.primary.opacity(0.6))
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
            Text(message)
                .font(.system(size: 13))
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 36)
        .padding(.horizontal, 24)
    }
}

// MARK: - Navigation helpers

extension View {
    func hideNavigationBar() -> some View {
        toolbar(.hidden, for: .navigationBar)
    }
}

/// Re-enables the swipe-back gesture when the system navigation bar is hidden.
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}
