import Foundation
import SwiftData

@Model
final class MetricLog {
    var date: Date
    var ordersOffered: Int
    var ordersCompleted: Int
    var scheduledMinutes: Int
    var workedMinutes: Int
    var deliveries: Int
    var onTimeDeliveries: Int
    var earningsCents: Int?

    init(date: Date = .now,
         ordersOffered: Int = 0, ordersCompleted: Int = 0,
         scheduledMinutes: Int = 0, workedMinutes: Int = 0,
         deliveries: Int = 0, onTimeDeliveries: Int = 0,
         earningsCents: Int? = nil) {
        self.date = date
        self.ordersOffered = ordersOffered
        self.ordersCompleted = ordersCompleted
        self.scheduledMinutes = scheduledMinutes
        self.workedMinutes = workedMinutes
        self.deliveries = deliveries
        self.onTimeDeliveries = onTimeDeliveries
        self.earningsCents = earningsCents
    }

    var ocr: Double {
        guard ordersOffered > 0 else { return 1.0 }
        return Double(ordersCompleted) / Double(ordersOffered)
    }

    var scr: Double {
        guard scheduledMinutes > 0 else { return 1.0 }
        return min(1.0, Double(workedMinutes) / Double(scheduledMinutes))
    }

    var otm: Double {
        guard deliveries > 0 else { return 1.0 }
        return Double(onTimeDeliveries) / Double(deliveries)
    }

    var earnings: Double? {
        earningsCents.map { Double($0) / 100.0 }
    }
}
