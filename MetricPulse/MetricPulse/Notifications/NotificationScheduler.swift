import UserNotifications

struct NotificationScheduler {
    static func reschedule(snapshot: WindowSnapshot) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        for alert in snapshot.agingAlerts {
            let content = AlertContentBuilder.agingContent(for: alert)
            var dc = DateComponents()
            dc.hour = 8; dc.minute = 0
            let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: false)
            let id = "aging-\(Int(alert.log.date.timeIntervalSince1970))"
            center.add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
        }

        if let tier = snapshot.currentTier {
            let content = AlertContentBuilder.statusContent(averages: snapshot.averages, tier: tier)
            var dc = DateComponents()
            dc.hour = 9; dc.minute = 0
            let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
            center.add(UNNotificationRequest(identifier: "daily-status", content: content, trigger: trigger))
        }

        center.setBadgeCount(snapshot.agingAlerts.count) { _ in }
    }
}
