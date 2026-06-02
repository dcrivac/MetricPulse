import SwiftUI

struct RequiredMetricRow: View {
    let label: String
    let current: Double
    let required: Double

    private var passing: Bool { current >= required }

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text(label).font(.subheadline.bold())
                Spacer()
                Text("Now \(Int(current * 100))%")
                    .font(.caption).foregroundStyle(.secondary)
                Text("Need \(Int(required * 100))%")
                    .font(.caption.bold())
                    .foregroundStyle(passing ? .green : .red)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(passing ? Color.green : Color.orange)
                        .frame(width: geo.size.width * min(current, 1.0))
                    Rectangle()
                        .fill(Color.primary.opacity(0.25))
                        .frame(width: 2)
                        .offset(x: geo.size.width * min(required, 1.0) - 1)
                }
            }
            .frame(height: 8)
        }
    }
}
