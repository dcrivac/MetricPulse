import Foundation
import Observation

@Observable
final class AppSettings {
    var driverName: String      { didSet { ud.set(driverName, forKey: "driverName") } }
    var market: String          { didSet { ud.set(market, forKey: "market") } }
    var onboardingComplete: Bool{ didSet { ud.set(onboardingComplete, forKey: "onboardingComplete") } }
    var notificationsEnabled: Bool { didSet { ud.set(notificationsEnabled, forKey: "notificationsEnabled") } }
    var partnerModeEnabled: Bool { didSet { ud.set(partnerModeEnabled, forKey: "partnerModeEnabled") } }

    private let ud = UserDefaults.standard

    init() {
        driverName           = ud.string(forKey: "driverName") ?? ""
        market               = ud.string(forKey: "market") ?? ""
        onboardingComplete   = ud.bool(forKey: "onboardingComplete")
        notificationsEnabled = ud.bool(forKey: "notificationsEnabled")
        partnerModeEnabled   = ud.bool(forKey: "partnerModeEnabled")
    }

    static let shared = AppSettings()
}
