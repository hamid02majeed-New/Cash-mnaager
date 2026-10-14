import SwiftUI

struct SettingsView: View {
    let isRoot: Bool
    @StateObject private var vm = SettingsViewModel()

    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "Settings", showsBack: !isRoot)

            ScrollView {
                VStack(spacing: 0) {
                    NavigationLink(value: AppRoute.account) {
                        HStack(spacing: 14) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(.white)
                                .frame(width: 42, height: 42)
                                .background(Theme.primary, in: Circle())
                            VStack(alignment: .leading, spacing: 2) {
                                Text(vm.accountName)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Theme.textPrimary)
                                Text("Manage your profile")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Theme.textSecondary)
                            }
                            Spacer()
                            chevron
                        }
                        .padding(.vertical, 14)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    Divider()

                    row(icon: "dollarsign.circle", title: "Currency", detail: vm.currencyDetail, route: .currency)
                    row(icon: "speedometer", title: "Budget", detail: vm.budgetDetail, route: .budget)
                    row(icon: "bell", title: "Notifications", detail: "Reminders & alerts", route: .notifications)
                    row(icon: "lock.shield.fill", title: "Data & Privacy", detail: nil, route: .privacy)
                    row(icon: "questionmark.circle", title: "Help & Support", detail: nil, route: .help)

                    Button { vm.showLogoutConfirm = true } label: {
                        HStack(spacing: 14) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 17))
                                .frame(width: 26)
                            Text("Log Out").font(.system(size: 15, weight: .medium))
                            Spacer()
                        }
                        .foregroundStyle(Theme.expense)
                        .padding(.vertical, 16)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
            }
        }
        .background(Theme.background)
        .hideNavigationBar()
        .modifier(OptionalTabBar(enabled: isRoot))
        .confirmationDialog("Log out of Pocket?", isPresented: $vm.showLogoutConfirm, titleVisibility: .visible) {
            Button("Log Out", role: .destructive) { vm.logOut() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Your data stays on this device.")
        }
    }

    private var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(Theme.textSecondary)
    }

    private func row(icon: String, title: String, detail: String?, route: AppRoute) -> some View {
        VStack(spacing: 0) {
            NavigationLink(value: route) {
                HStack(spacing: 14) {
                    Image(systemName: icon)
                        .font(.system(size: 17))
                        .foregroundStyle(Theme.textPrimary)
                        .frame(width: 26)
                    Text(title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                    if let detail {
                        Text(detail).font(.system(size: 12)).foregroundStyle(Theme.textSecondary)
                    }
                    chevron
                }
                .padding(.vertical, 16)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            Divider()
        }
    }
}

private struct OptionalTabBar: ViewModifier {
    let enabled: Bool
    func body(content: Content) -> some View {
        if enabled { content.mainTabBar() } else { content }
    }
}
