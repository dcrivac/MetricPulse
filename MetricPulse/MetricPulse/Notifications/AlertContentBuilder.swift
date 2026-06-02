import UserNotifications

struct AlertContentBuilder {
    static func agingContent(for alert: AgingAlert) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Shift Aging Out"

        var metrics: [String] = []
        if alert.affectsOCR { metrics.append("OCR") }
        if alert.affectsSCR { metrics.append("SCR") }
        if alert.affectsOTM { metrics.append("OTM") }

        let when = alert.daysUntilDrop == 0 ? "today"
                 : alert.daysUntilDrop == 1 ? "tomorrow"
                 : "in \(alert.daysUntilDrop) days"
        content.body  = "A strong \(metrics.joined(separator: "/")) shift expires \(when). Log a shift to maintain your average."
        content.sound = .default
        return content
    }

    static func statusContent(averages: MetricAverages, tier: TierConfig) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Metrics Check"

        var low: [String] = []
        if averages.ocr < tier.minOCR { low.append("OCR \(Int(averages.ocr * 100))%") }
        if averages.scr < tier.minSCR { low.append("SCR \(Int(averages.scr * 100))%") }
        if averages.otm < tier.minOTM { low.append("OTM \(Int(averages.otm * 100))%") }

        content.body  = low.isEmpty
            ? "You're on track for \(tier.name) tier. Keep it up!"
            : "Below \(tier.name) threshold: \(low.joined(separator: ", "))"
        content.sound = .default
        return content
    }
}
