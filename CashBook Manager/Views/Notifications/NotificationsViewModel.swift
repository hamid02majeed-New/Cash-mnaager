import Combine
import Foundation
import UserNotifications

final class NotificationsViewModel: StoreViewModel {
    @Published var showPermissionAlert = false
    private let reminderID = "daily-reminder"

    var isEnabled: Bool { store.remindersEnabled }

    func setReminders(_ enabled: Bool) {
        let center = UNUserNotificationCenter.current()
        guard enabled else {
            center.removePendingNotificationRequests(withIdentifiers: [reminderID])
            store.remindersEnabled = false
            return
        }
        Task {
            let granted = (try? await center.requestAuthorization(options: [.alert, .sound])) ?? false
            guard granted else {
                store.remindersEnabled = false
                showPermissionAlert = true
                return
            }
            let content = UNMutableNotificationContent()
            content.title = "Pocket"
            content.body = "Don't forget to log today's income and expenses."
            content.sound = .default
            var time = DateComponents()
            time.hour = 20
            let request = UNNotificationRequest(
                identifier: reminderID,
                content: content,
                trigger: UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
            )
            try? await center.add(request)
            store.remindersEnabled = true
        }
    }
}
