import SwiftUI

struct AchievabilityBanner: View {
    let achievable: Bool
    let shiftsNeeded: Int
    let tierName: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: achievable ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.title2)
                .foregroundStyle(achievable ? .green : .red)
            VStack(alignment: .leading, spacing: 2) {
                Text(achievable ? "\(tierName) Achievable" : "\(tierName) Out of Reach")
                    .font(.subheadline.bold())
                if achievable && shiftsNeeded > 0 {
                    Text("\(shiftsNeeded) perfect shift\(shiftsNeeded == 1 ? "" : "s") needed")
                        .font(.caption).foregroundStyle(.secondary)
                } else if achievable && shiftsNeeded == 0 {
                    Text("You're already there!").font(.caption).foregroundStyle(.secondary)
                } else {
                    Text("Not enough days left in the window").font(.caption).foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background((achievable ? Color.green : Color.red).opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
