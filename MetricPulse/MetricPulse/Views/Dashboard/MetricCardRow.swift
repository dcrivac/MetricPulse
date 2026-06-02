import SwiftUI

struct MetricCardRow: View {
    let averages: MetricAverages
    let tiers: [TierConfig]

    private var premier: TierConfig? {
        tiers.sorted { $0.sortOrder < $1.sortOrder }.first
    }

    var body: some View {
        HStack(spacing: 10) {
            MetricCard(label: "OCR", value: averages.ocr, threshold: premier?.minOCR ?? 0.90)
            MetricCard(label: "SCR", value: averages.scr, threshold: premier?.minSCR ?? 0.90)
            MetricCard(label: "OTM", value: averages.otm, threshold: premier?.minOTM ?? 0.85)
        }
    }
}

private struct MetricCard: View {
    let label: String
    let value: Double
    let threshold: Double

    private var passing: Bool { value >= threshold }

    var body: some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            Text("\(Int(value * 100))%")
                .font(.title2.bold())
                .foregroundStyle(passing ? .green : .red)
            ProgressView(value: min(value, 1.0))
                .tint(passing ? .green : .red)
            Text("Goal \(Int(threshold * 100))%")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
