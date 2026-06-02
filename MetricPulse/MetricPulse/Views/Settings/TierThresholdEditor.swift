import SwiftUI

struct TierThresholdEditor: View {
    @Bindable var tier: TierConfig
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Form {
            Section("OCR — Order Completion Rate") {
                ThresholdSlider(label: "Minimum", value: $tier.minOCR)
            }
            Section("SCR — Schedule Compliance Rate") {
                ThresholdSlider(label: "Minimum", value: $tier.minSCR)
            }
            Section("OTM — On Time or More") {
                ThresholdSlider(label: "Minimum", value: $tier.minOTM)
            }
        }
        .navigationTitle(tier.name)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: tier.minOCR) { _, _ in try? modelContext.save() }
        .onChange(of: tier.minSCR) { _, _ in try? modelContext.save() }
        .onChange(of: tier.minOTM) { _, _ in try? modelContext.save() }
    }
}

private struct ThresholdSlider: View {
    let label: String
    @Binding var value: Double

    var body: some View {
        VStack {
            HStack {
                Text(label)
                Spacer()
                Text("\(Int(value * 100))%")
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
            Slider(value: $value, in: 0...1, step: 0.01)
        }
    }
}
