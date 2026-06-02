import SwiftUI

struct PartnerModeSection: View {
    @Environment(AppSettings.self) private var settings

    var body: some View {
        Section("Partner Mode") {
            @Bindable var s = settings
            Toggle("Two-Driver Household", isOn: $s.partnerModeEnabled)
            if settings.partnerModeEnabled {
                Text("Track metrics for two accounts. Full support coming in a future update.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
