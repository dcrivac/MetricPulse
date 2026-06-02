import UserNotifications
import Observation

@Observable
final class NotificationPermission {
    var status: UNAuthorizationStatus = .notDetermined

    func refresh() {
        let settings = UNUserNotificationCenter.current().notificationSettings()
        status = settings.authorizationStatus
    }

    func request() async {
        guard let granted = try? await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound]),
              granted else { return }
        refresh()
    }
}
