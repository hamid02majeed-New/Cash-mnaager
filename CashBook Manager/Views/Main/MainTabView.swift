import SwiftUI

struct MainTabView: View {
    @StateObject private var vm = MainTabViewModel()

    var body: some View {
        Group {
            switch vm.selection {
            case .home:
                NavigationStack { HomeView().appDestinations() }
            case .analytics:
                NavigationStack { AnalyticsView().appDestinations() }
            case .more:
                NavigationStack { SettingsView(isRoot: true).appDestinations() }
            }
        }
        .environmentObject(vm)
        .fullScreenCover(isPresented: $vm.isAddingTransaction) {
            NavigationStack {
                AddTransactionView(onSaved: { vm.select(.home) })
            }
        }
    }
}

/// Bottom bar shown on the three root screens (Home, Analytics, More).
struct AppTabBar: View {
    @EnvironmentObject private var tabs: MainTabViewModel

    var body: some View {
        HStack {
            item(icon: "house.fill", title: "Home", tab: .home)
            addItem
            item(icon: "chart.bar.fill", title: "Analytics", tab: .analytics)
            item(icon: "ellipsis", title: "More", tab: .more)
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(Color.white.shadow(color: .black.opacity(0.08), radius: 8, y: -2).ignoresSafeArea(edges: .bottom))
    }

    private func item(icon: String, title: String, tab: MainTab) -> some View {
        let selected = tabs.selection == tab
        return Button { tabs.select(tab) } label: {
            VStack(spacing: 3) {
                Image(systemName: icon).font(.system(size: 19, weight: .semibold)).frame(height: 24)
                Text(title).font(.system(size: 10, weight: .medium))
            }
            .foregroundStyle(selected ? Theme.primary : Theme.textSecondary)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var addItem: some View {
        Button { tabs.addTapped() } label: {
            VStack(spacing: 3) {
                Image(systemName: "plus.circle").font(.system(size: 19, weight: .semibold)).frame(height: 24)
                Text("Add").font(.system(size: 10, weight: .medium))
            }
            .foregroundStyle(Theme.textSecondary)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

extension View {
    func mainTabBar() -> some View {
        safeAreaInset(edge: .bottom, spacing: 0) { AppTabBar() }
    }
}
