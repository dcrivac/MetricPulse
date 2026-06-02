import SwiftUI

struct ScenarioCompareView: View {
    let windowLogs: [MetricLog]
    let tiers: [TierConfig]

    private var premier: TierConfig? { tiers.sorted { $0.sortOrder < $1.sortOrder }.first }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Scenario: Add 1–7 Perfect Shifts")
                .font(.subheadline.bold())

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Shifts").frame(height: 30).font(.caption2.bold()).foregroundStyle(.secondary)
                        Text("OCR").frame(height: 30).font(.caption)
                        Text("SCR").frame(height: 30).font(.caption)
                        Text("OTM").frame(height: 30).font(.caption)
                    }
                    .padding(.horizontal, 8)

                    ForEach(1...7, id: \.self) { n in
                        let p = projected(adding: n)
                        VStack(spacing: 0) {
                            Text("\(n)").frame(height: 30).font(.caption2.bold()).foregroundStyle(.secondary)
                            rateCell(p.ocr, threshold: premier?.minOCR ?? 0.9)
                            rateCell(p.scr, threshold: premier?.minSCR ?? 0.9)
                            rateCell(p.otm, threshold: premier?.minOTM ?? 0.85)
                        }
                        .frame(width: 52)
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func rateCell(_ v: Double, threshold: Double) -> some View {
        Text("\(Int(v * 100))%")
            .font(.caption.monospacedDigit())
            .frame(height: 30)
            .foregroundStyle(v >= threshold ? Color.green : Color.red)
    }

    private func projected(adding n: Int) -> (ocr: Double, scr: Double, otm: Double) {
        let count = windowLogs.count + n
        guard count > 0 else { return (1, 1, 1) }
        let d = Double(count)
        let ocr = (windowLogs.map(\.ocr).reduce(0, +) + Double(n)) / d
        let scr = (windowLogs.map(\.scr).reduce(0, +) + Double(n)) / d
        let otm = (windowLogs.map(\.otm).reduce(0, +) + Double(n)) / d
        return (ocr, scr, otm)
    }
}
