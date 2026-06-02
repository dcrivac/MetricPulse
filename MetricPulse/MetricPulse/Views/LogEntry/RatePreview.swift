import SwiftUI

struct RatePreview: View {
    let label: String
    let value: Double
    let threshold: Double

    var body: some View {
        HStack(spacing: 4) {
            Text(label).font(.caption.bold())
            Text("\(Int(value * 100))%").font(.caption.monospacedDigit())
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background((value >= threshold ? Color.green : Color.red).opacity(0.15))
        .foregroundStyle(value >= threshold ? Color.green : Color.red)
        .clipShape(Capsule())
    }
}
