import SwiftUI

struct StepperRow: View {
    let label: String
    let subtitle: String
    @Binding var value: Int
    var range: ClosedRange<Int> = 0...999

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.subheadline.bold())
                Text(subtitle).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Stepper(value: $value, in: range) {
                Text("\(value)")
                    .font(.subheadline.monospacedDigit())
                    .frame(minWidth: 32, alignment: .trailing)
            }
        }
    }
}
