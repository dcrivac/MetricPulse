import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query private var logs: [MetricLog]
    @Query private var tiers: [TierConfig]
    @Environment(AppSettings.self) private var settings

    private var snapshot: WindowSnapshot {
        MetricEngine.snapshot(logs: logs, tiers: tiers)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    TierBadgeView(tier: snapshot.currentTier)
                    WindowStripView(logs: snapshot.logs)
                    MetricCardRow(averages: snapshot.averages, tiers: tiers)

                    if let proj = snapshot.projection {
                        projectionBanner(proj)
                    }

                    ForEach(snapshot.agingAlerts) { alert in
                        AgingAlertCard(alert: alert)
                    }
                }
                .padding()
            }
            .navigationTitle(settings.driverName.isEmpty ? "Dashboard" : "Hi, \(settings.driverName)")
        }
    }

    private func projectionBanner(_ proj: DayProjection) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "arrow.up.circle.fill").foregroundStyle(.blue)
            Text("\(proj.shiftsNeeded) perfect shift\(proj.shiftsNeeded == 1 ? "" : "s") to reach \(proj.targetTier.name)")
                .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
