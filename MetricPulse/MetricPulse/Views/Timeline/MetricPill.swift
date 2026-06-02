import SwiftUI

struct MetricPill: View {
    let label: String
    let passing: Bool

    var body: some View {
        Text(label)
            .font(.caption2.bold())
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background((passing ? Color.green : Color.red).opacity(0.18))
            .foregroundStyle(passing ? Color.green : Color.red)
            .clipShape(Capsule())
    }
}
