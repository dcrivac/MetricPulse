import Foundation
import SwiftData

@Model
final class TierConfig {
    var name: String
    var minOCR: Double
    var minSCR: Double
    var minOTM: Double
    var sortOrder: Int

    init(name: String, minOCR: Double, minSCR: Double, minOTM: Double, sortOrder: Int) {
        self.name = name
        self.minOCR = minOCR
        self.minSCR = minSCR
        self.minOTM = minOTM
        self.sortOrder = sortOrder
    }

    func qualifies(ocr: Double, scr: Double, otm: Double) -> Bool {
        ocr >= minOCR && scr >= minSCR && otm >= minOTM
    }

    static var defaults: [TierConfig] {
        [
            TierConfig(name: "Premier", minOCR: 0.90, minSCR: 0.90, minOTM: 0.85, sortOrder: 0),
            TierConfig(name: "Plus",    minOCR: 0.85, minSCR: 0.85, minOTM: 0.80, sortOrder: 1),
            TierConfig(name: "Standard",minOCR: 0.00, minSCR: 0.00, minOTM: 0.00, sortOrder: 2),
        ]
    }
}
