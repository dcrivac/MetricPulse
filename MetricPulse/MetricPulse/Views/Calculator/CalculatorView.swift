import SwiftUI
import SwiftData

struct CalculatorView: View {
    @Query private var logs: [MetricLog]
    @Query private var tiers: [TierConfig]

    private var snapshot: WindowSnapshot { MetricEngine.snapshot(logs: logs, tiers: tiers) }
    private var premier: TierConfig? { tiers.sorted { $0.sortOrder < $1.sortOrder }.first }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if let proj = snapshot.projection {
                        AchievabilityBanner(achievable: true, shiftsNeeded: proj.shiftsNeeded, tierName: proj.targetTier.name)
                    } else if !snapshot.averages.isEmpty {
                        let onPremier = snapshot.currentTier?.sortOrder == 0
                        AchievabilityBanner(achievable: onPremier, shiftsNeeded: 0, tierName: premier?.name ?? "Premier")
                    }

                    VStack(spacing: 12) {
                        RequiredMetricRow(label: "OCR", current: snapshot.averages.ocr, required: premier?.minOCR ?? 0.9)
                        RequiredMetricRow(label: "SCR", current: snapshot.averages.scr, required: premier?.minSCR ?? 0.9)
                        RequiredMetricRow(label: "OTM", current: snapshot.averages.otm, required: premier?.minOTM ?? 0.85)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    ScenarioCompareView(windowLogs: snapshot.logs, tiers: tiers)
                }
                .padding()
            }
            .navigationTitle("Calculator")
        }
    }
}
