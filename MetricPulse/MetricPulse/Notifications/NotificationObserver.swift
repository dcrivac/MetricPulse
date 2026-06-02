import UserNotifications
import Observation

@Observable
final class NotificationObserver: NSObject, UNUserNotificationCenterDelegate {
    var deepLinkTab: Int? = nil
    var shouldReschedule = false

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler done: @escaping () -> Void) {
        let id = response.notification.request.identifier
        deepLinkTab = id.hasPrefix("aging-") ? 0 : id == "daily-status" ? 0 : nil
        done()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler done: @escaping (UNNotificationPresentationOptions) -> Void) {
        done([.banner, .sound])
    }
}
