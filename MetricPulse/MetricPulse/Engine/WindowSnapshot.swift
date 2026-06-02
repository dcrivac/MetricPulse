import Foundation

struct WindowSnapshot {
    let logs: [MetricLog]
    let averages: MetricAverages
    let currentTier: TierConfig?
    let agingAlerts: [AgingAlert]
    let projection: DayProjection?
}

struct MetricAverages {
    let ocr: Double
    let scr: Double
    let otm: Double
    let logCount: Int

    var isEmpty: Bool { logCount == 0 }

    static let empty = MetricAverages(ocr: 0, scr: 0, otm: 0, logCount: 0)
}

struct AgingAlert: Identifiable {
    let id = UUID()
    let log: MetricLog
    let daysUntilDrop: Int
    let affectsOCR: Bool
    let affectsSCR: Bool
    let affectsOTM: Bool
}

struct DayProjection {
    let shiftsNeeded: Int
    let targetTier: TierConfig
}
