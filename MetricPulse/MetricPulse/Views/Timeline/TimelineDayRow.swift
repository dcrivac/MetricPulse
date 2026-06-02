import SwiftUI

struct TimelineDayRow: View {
    let log: MetricLog
    let tier: TierConfig?

    private var inWindow: Bool {
        let cutoff = Calendar.current.startOfDay(for: Date()).addingTimeInterval(-13 * 86400)
        return Calendar.current.startOfDay(for: log.date) >= cutoff
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(log.date, format: .dateTime.month(.abbreviated).day().year())
                    .font(.subheadline.bold())
                if !inWindow {
                    Text("Expired").font(.caption2).foregroundStyle(.tertiary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            MetricPill(label: "\(Int(log.ocr * 100))%", passing: log.ocr >= (tier?.minOCR ?? 0.9))
                .frame(width: 54)
            MetricPill(label: "\(Int(log.scr * 100))%", passing: log.scr >= (tier?.minSCR ?? 0.9))
                .frame(width: 54)
            MetricPill(label: "\(Int(log.otm * 100))%", passing: log.otm >= (tier?.minOTM ?? 0.85))
                .frame(width: 54)
        }
        .opacity(inWindow ? 1.0 : 0.45)
    }
}
