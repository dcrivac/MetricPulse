import SwiftUI
import SwiftData

struct MainTabView: View {
    @Query private var logs: [MetricLog]
    @Query private var tiers: [TierConfig]
    @State private var selectedTab = 0
    @State private var observer = NotificationObserver()

    private var snapshot: WindowSnapshot { MetricEngine.snapshot(logs: logs, tiers: tiers) }

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem { Label("Dashboard", systemImage: "chart.bar.fill") }
                .tag(0)
            TimelineView()
                .tabItem { Label("Timeline", systemImage: "calendar") }
                .tag(1)
            LogEntryView()
                .tabItem { Label("Log", systemImage: "plus.circle.fill") }
                .tag(2)
            CalculatorView()
                .tabItem { Label("Calculator", systemImage: "function") }
                .tag(3)
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
                .tag(4)
        }
        .onChange(of: observer.deepLinkTab) { _, tab in
            if let tab { selectedTab = tab }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            NotificationScheduler.reschedule(snapshot: snapshot)
        }
    }
}
