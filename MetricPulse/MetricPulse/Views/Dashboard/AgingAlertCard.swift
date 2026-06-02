import SwiftUI

struct AgingAlertCard: View {
    let alert: AgingAlert

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "clock.badge.exclamationmark.fill")
                .font(.title2)
                .foregroundStyle(.orange)

            VStack(alignment: .leading, spacing: 2) {
                Text(dropLabel)
                    .font(.subheadline.bold())
                Text(alert.log.date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 4) {
                if alert.affectsOCR { MetricPill(label: "OCR", passing: false) }
                if alert.affectsSCR { MetricPill(label: "SCR", passing: false) }
                if alert.affectsOTM { MetricPill(label: "OTM", passing: false) }
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var dropLabel: String {
        switch alert.daysUntilDrop {
        case 0:  return "Strong shift expires today"
        case 1:  return "Strong shift expires tomorrow"
        default: return "Strong shift expires in \(alert.daysUntilDrop) days"
        }
    }
}
