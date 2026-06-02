import SwiftUI

struct TierBadgeView: View {
    let tier: TierConfig?

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Current Tier")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(tier?.name ?? "No Data")
                    .font(.largeTitle.bold())
                    .foregroundStyle(tierColor)
            }
            Spacer()
            Image(systemName: tierIcon)
                .font(.system(size: 44))
                .foregroundStyle(tierColor)
        }
        .padding()
        .background(tierColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var tierColor: Color {
        switch tier?.name {
        case "Premier": return .yellow
        case "Plus":    return .blue
        default:        return Color(.secondaryLabel)
        }
    }

    private var tierIcon: String {
        switch tier?.name {
        case "Premier": return "star.fill"
        case "Plus":    return "star.leadinghalf.filled"
        default:        return "star"
        }
    }
}
