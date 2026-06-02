import Foundation
import SwiftData

@Model
final class Metric {
    var name: String
    var value: Double
    var unit: String
    var timestamp: Date

    init(name: String, value: Double, unit: String, timestamp: Date = .now) {
        self.name = name
        self.value = value
        self.unit = unit
        self.timestamp = timestamp
    }
}
