import SwiftUI

struct CurrencyView: View {
    @StateObject private var vm = CurrencyViewModel()

    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "Currency")
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(vm.currencies) { currency in
                        Button { vm.select(currency) } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(currency.name)
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundStyle(Theme.textPrimary)
                                    Text(currency.label)
                                        .font(.system(size: 12))
                                        .foregroundStyle(Theme.textSecondary)
                                }
                                Spacer()
                                if currency.code == vm.selectedCode {
                                    Image(systemName: "checkmark").foregroundStyle(Theme.primary)
                                }
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        Divider().padding(.leading, 16)
                    }
                }
            }
        }
        .background(Theme.background)
        .hideNavigationBar()
    }
}
