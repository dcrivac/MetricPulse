import SwiftUI

struct OnboardingMetricsPage: View {
    @State private var expanded: String? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Your Three Metrics")
                    .font(.title2.bold())
                    .padding(.top, 32)

                Text("GrubHub evaluates OCR, SCR, and OTM over a rolling 14-day window to determine your driver tier.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                ExplainerCard(label: "OCR", name: "Order Completion Rate",
                    detail: "Percentage of dispatched orders you delivered. Canceling or declining after acceptance lowers this.",
                    threshold: "90% for Premier",
                    isExpanded: expanded == "OCR") { expanded = expanded == "OCR" ? nil : "OCR" }

                ExplainerCard(label: "SCR", name: "Schedule Compliance Rate",
                    detail: "How much of your scheduled block you worked. Leaving early or no-showing impacts this.",
                    threshold: "90% for Premier",
                    isExpanded: expanded == "SCR") { expanded = expanded == "SCR" ? nil : "SCR" }

                ExplainerCard(label: "OTM", name: "On Time or More",
                    detail: "Percentage of deliveries where you arrived at the restaurant on time or ahead of schedule.",
                    threshold: "85% for Premier",
                    isExpanded: expanded == "OTM") { expanded = expanded == "OTM" ? nil : "OTM" }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

private struct ExplainerCard: View {
    let label: String
    let name: String
    let detail: String
    let threshold: String
    let isExpanded: Bool
    let toggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: toggle) {
                HStack {
                    MetricPill(label: label, passing: true)
                    Text(name).font(.subheadline.bold())
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .foregroundStyle(.primary)

            if isExpanded {
                Text(detail).font(.subheadline).foregroundStyle(.secondary)
                Text(threshold).font(.caption.bold()).foregroundStyle(.yellow)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
