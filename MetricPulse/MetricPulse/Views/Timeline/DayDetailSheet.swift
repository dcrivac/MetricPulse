import SwiftUI

struct DayDetailSheet: View {
    let log: MetricLog
    let tier: TierConfig?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Date") {
                    Text(log.date, style: .date)
                }
                Section("Metrics") {
                    metricRow("OCR", value: log.ocr, threshold: tier?.minOCR ?? 0.9,
                              detail: "\(log.ordersCompleted) of \(log.ordersOffered) orders")
                    metricRow("SCR", value: log.scr, threshold: tier?.minSCR ?? 0.9,
                              detail: "\(log.workedMinutes) of \(log.scheduledMinutes) min")
                    metricRow("OTM", value: log.otm, threshold: tier?.minOTM ?? 0.85,
                              detail: "\(log.onTimeDeliveries) of \(log.deliveries) on time")
                }
                if let earnings = log.earnings {
                    Section("Earnings") {
                        Text(earnings, format: .currency(code: "USD"))
                    }
                }
            }
            .navigationTitle("Shift Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func metricRow(_ label: String, value: Double, threshold: Double, detail: String) -> some View {
        HStack {
            Text(label).bold()
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                MetricPill(label: "\(Int(value * 100))%", passing: value >= threshold)
                Text(detail).font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}
