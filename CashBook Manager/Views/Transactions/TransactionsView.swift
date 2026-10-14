import SwiftUI

struct TransactionsView: View {
    @StateObject private var vm = TransactionsViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Transactions")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                sortMenu
            }
            .frame(height: 44)
            .padding(.horizontal, 16)

            SearchField(text: $vm.searchText, placeholder: "Search transactions...")
                .padding(.horizontal, 16)
                .padding(.vertical, 6)

            filterChips

            let sections = vm.sections
            if sections.isEmpty {
                EmptyStateView(icon: "list.bullet.rectangle", title: "No transactions",
                               message: "Nothing matches your search or filter.")
                Spacer()
            } else {
                list(sections)
            }
        }
        .background(Theme.background)
        .hideNavigationBar()
    }

    private var sortMenu: some View {
        Menu {
            Picker("Sort by", selection: $vm.sort) {
                ForEach(TransactionSort.allCases) { Text($0.rawValue).tag($0) }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Theme.textPrimary)
                .frame(width: 40, height: 40)
        }
    }

    private var filterChips: some View {
        HStack(spacing: 10) {
            ForEach(TransactionFilter.allCases) { filter in
                let selected = vm.filter == filter
                Button { vm.filter = filter } label: {
                    Text(filter.rawValue)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(selected ? Color.white : Theme.textSecondary)
                        .padding(.horizontal, 18)
                        .frame(height: 34)
                        .background(selected ? Theme.primary : Theme.field, in: Capsule())
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private func list(_ sections: [TransactionSection]) -> some View {
        List {
            ForEach(sections) { section in
                Section {
                    ForEach(section.items) { transaction in
                        TransactionRow(transaction: transaction, currency: vm.currency)
                            .overlay {
                                NavigationLink(value: AppRoute.edit(transaction.id)) { EmptyView() }.opacity(0)
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            .swipeActions {
                                Button(role: .destructive) { vm.delete(transaction) } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                } header: {
                    Text(section.title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Theme.textPrimary)
                        .textCase(nil)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}
