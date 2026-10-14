import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                header
                summaryCards.offset(y: 44)
            }
            .zIndex(1)

            ScrollView {
                recentSection
                    .padding(.top, 64)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
        }
        .background(Theme.background)
        .hideNavigationBar()
        .mainTabBar()
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Pocket").font(.system(size: 20, weight: .bold))
                Spacer()
                NavigationLink(value: AppRoute.settings) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 19))
                        .frame(width: 36, height: 36)
                }
            }
            Text("Total Balance").font(.system(size: 13)).opacity(0.9)
            Text(vm.balanceText).font(.system(size: 32, weight: .bold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 20)
        .padding(.bottom, 64)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            UnevenRoundedRectangle(bottomLeadingRadius: 24, bottomTrailingRadius: 24)
                .fill(Theme.primary)
                .ignoresSafeArea(edges: .top)
        }
    }

    private var summaryCards: some View {
        HStack(spacing: 12) {
            summaryCard(title: "Income", amount: vm.incomeText, icon: "arrow.up", color: Theme.income)
            summaryCard(title: "Expenses", amount: vm.expenseText, icon: "arrow.down", color: Theme.expense)
        }
        .padding(.horizontal, 16)
    }

    private func summaryCard(title: String, amount: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(color)
                    .frame(width: 26, height: 26)
                    .background(color.opacity(0.14), in: Circle())
                Text(title).font(.system(size: 12, weight: .medium)).foregroundStyle(color)
            }
            Text(amount)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Recent Transactions")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
                NavigationLink(value: AppRoute.transactions) {
                    Text("See All").font(.system(size: 13, weight: .medium)).foregroundStyle(Theme.primary)
                }
            }
            if vm.recent.isEmpty {
                EmptyStateView(icon: "tray", title: "No transactions yet",
                               message: "Tap Add below to record your first income or expense.")
            } else {
                ForEach(vm.recent) { transaction in
                    NavigationLink(value: AppRoute.edit(transaction.id)) {
                        TransactionRow(transaction: transaction, currency: vm.currency, relativeDate: true)
                    }
                    .buttonStyle(.plain)
                    if transaction.id != vm.recent.last?.id { Divider() }
                }
            }
        }
    }
}
