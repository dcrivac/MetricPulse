import SwiftUI

struct OnboardingWelcomePage: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 80))
                .foregroundStyle(.yellow)

            VStack(spacing: 8) {
                Text("Metric Pulse")
                    .font(.largeTitle.bold())
                Text("Your GrubHub Premier tracker")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 20) {
                FeatureBullet(icon: "chart.bar.xaxis",
                              title: "14-Day Rolling Window",
                              subtitle: "See exactly where your OCR, SCR, and OTM stand")
                FeatureBullet(icon: "bell.badge",
                              title: "Smart Alerts",
                              subtitle: "Know when a strong shift is about to age out")
                FeatureBullet(icon: "function",
                              title: "What-If Calculator",
                              subtitle: "Project how many shifts you need to hit Premier")
            }
            .padding(.horizontal, 32)

            Spacer()
        }
    }
}

private struct FeatureBullet: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.yellow)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline.bold())
                Text(subtitle).font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}
