import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(AppSettings.self) private var settings
    @Query private var tiers: [TierConfig]
    @State private var showNotifications = false
    @State private var showAcknowledgements = false

    var body: some View {
        NavigationStack {
            List {
                Section("Profile") {
                    @Bindable var s = settings
                    LabeledContent("Name") {
                        TextField("Your name", text: $s.driverName)
                            .multilineTextAlignment(.trailing)
                    }
                    LabeledContent("Market") {
                        TextField("City", text: $s.market)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section("Tier Thresholds") {
                    ForEach(tiers.sorted { $0.sortOrder < $1.sortOrder }) { tier in
                        NavigationLink(tier.name) {
                            TierThresholdEditor(tier: tier)
                        }
                    }
                }

                Section("Notifications") {
                    Button("Notification Settings") { showNotifications = true }
                        .foregroundStyle(.primary)
                }

                PartnerModeSection()
                DataManagementSection()

                Section {
                    Button("Acknowledgements") { showAcknowledgements = true }
                        .foregroundStyle(.secondary)
                    Link("Privacy Policy",
                         destination: URL(string: "https://crivac.com/metric-pulse/privacy")!)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showNotifications) { NotificationSettingsView() }
            .sheet(isPresented: $showAcknowledgements) { AcknowledgementsView() }
        }
    }
}

struct NotificationSettingsView: View {
    @Environment(AppSettings.self) private var settings
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            @Bindable var s = settings
            Form {
                Toggle("Enable Notifications", isOn: $s.notificationsEnabled)
                Text("Alerts when a strong shift is aging out and a daily status summary.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } }
            }
        }
    }
}

struct AcknowledgementsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Built with Swift, SwiftUI, and SwiftData.")
                    Text("No third-party libraries.")
                }
                Section("Developer") {
                    Text("David Crivac — GrubHub driver, San Diego")
                    Link("crivac.com", destination: URL(string: "https://crivac.com")!)
                }
            }
            .navigationTitle("Acknowledgements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } }
            }
        }
    }
}
