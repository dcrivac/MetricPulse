import Foundation

struct MetricEngine {
    static let windowDays = 14

    static func snapshot(logs: [MetricLog], tiers: [TierConfig]) -> WindowSnapshot {
        let window = windowLogs(from: logs)
        let avgs   = averages(from: window)
        let tier   = currentTier(averages: avgs, tiers: tiers)
        let alerts = agingAlerts(from: window, tiers: tiers)
        let proj   = projection(windowLogs: window, averages: avgs, tiers: tiers)
        return WindowSnapshot(logs: window, averages: avgs, currentTier: tier, agingAlerts: alerts, projection: proj)
    }

    static func windowLogs(from logs: [MetricLog]) -> [MetricLog] {
        let cal    = Calendar.current
        let cutoff = cal.startOfDay(for: Date()).addingTimeInterval(-Double(windowDays - 1) * 86400)
        return logs.filter { cal.startOfDay(for: $0.date) >= cutoff }
                   .sorted { $0.date > $1.date }
    }

    static func averages(from logs: [MetricLog]) -> MetricAverages {
        guard !logs.isEmpty else { return .empty }
        let n   = Double(logs.count)
        let ocr = logs.map(\.ocr).reduce(0, +) / n
        let scr = logs.map(\.scr).reduce(0, +) / n
        let otm = logs.map(\.otm).reduce(0, +) / n
        return MetricAverages(ocr: ocr, scr: scr, otm: otm, logCount: logs.count)
    }

    static func currentTier(averages: MetricAverages, tiers: [TierConfig]) -> TierConfig? {
        guard !averages.isEmpty else { return nil }
        return tiers.sorted { $0.sortOrder < $1.sortOrder }
                    .first { $0.qualifies(ocr: averages.ocr, scr: averages.scr, otm: averages.otm) }
    }

    static func agingAlerts(from logs: [MetricLog], tiers: [TierConfig]) -> [AgingAlert] {
        guard let premier = tiers.sorted(by: { $0.sortOrder < $1.sortOrder }).first else { return [] }
        let cal   = Calendar.current
        let today = cal.startOfDay(for: Date())

        return logs.compactMap { log in
            let logDay      = cal.startOfDay(for: log.date)
            let daysIn      = cal.dateComponents([.day], from: logDay, to: today).day ?? 0
            let daysUntilDrop = (windowDays - 1) - daysIn
            guard daysUntilDrop >= 0, daysUntilDrop <= 3 else { return nil }

            let affectsOCR = log.ocr >= premier.minOCR
            let affectsSCR = log.scr >= premier.minSCR
            let affectsOTM = log.otm >= premier.minOTM
            guard affectsOCR || affectsSCR || affectsOTM else { return nil }

            return AgingAlert(log: log, daysUntilDrop: daysUntilDrop,
                              affectsOCR: affectsOCR, affectsSCR: affectsSCR, affectsOTM: affectsOTM)
        }.sorted { $0.daysUntilDrop < $1.daysUntilDrop }
    }

    static func projection(windowLogs: [MetricLog], averages: MetricAverages, tiers: [TierConfig]) -> DayProjection? {
        guard let premier = tiers.sorted(by: { $0.sortOrder < $1.sortOrder }).first,
              premier.sortOrder == 0 else { return nil }
        guard !premier.qualifies(ocr: averages.ocr, scr: averages.scr, otm: averages.otm) else { return nil }

        let n = windowLogs.count
        func shifts(total: Double, count: Int, target: Double) -> Int {
            guard target < 1.0 else { return count == 0 ? 1 : 0 }
            let need = (target * Double(count) - total) / (1.0 - target)
            return need <= 0 ? 0 : Int(ceil(need))
        }

        let ocrShifts = shifts(total: averages.ocr * Double(n), count: n, target: premier.minOCR)
        let scrShifts = shifts(total: averages.scr * Double(n), count: n, target: premier.minSCR)
        let otmShifts = shifts(total: averages.otm * Double(n), count: n, target: premier.minOTM)
        let needed    = max(ocrShifts, scrShifts, otmShifts)

        // If needed > remaining days in window, it's not achievable this window
        let remaining = windowDays - n
        guard needed <= remaining else { return nil }

        return DayProjection(shiftsNeeded: needed, targetTier: premier)
    }
}
