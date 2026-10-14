import SwiftUI

struct NotificationsView: View {
    @StateObject private var vm = NotificationsViewModel()

    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "Notifications")
            VStack(alignment: .leading, spacing: 10) {
                Toggle(isOn: Binding(get: { vm.isEnabled }, set: vm.setReminders)) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Daily reminder")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Theme.textPrimary)
                        Text("Get a nudge at 8:00 PM to log your spending.")
                            .font(.system(size: 12))
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                .tint(Theme.primary)
                .padding(.vertical, 8)
                Spacer()
            }
            .padding(16)
        }
        .background(Theme.background)
        .hideNavigationBar()
        .alert("Notifications are off", isPresented: $vm.showPermissionAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Enable notifications for Pocket in the Settings app to receive reminders.")
        }
    }
}
