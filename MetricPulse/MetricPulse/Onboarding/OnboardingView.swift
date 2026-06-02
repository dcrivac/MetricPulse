import SwiftUI

struct OnboardingView: View {
    @Environment(AppSettings.self) private var settings
    @State private var page = 0
    @State private var name = ""
    @State private var market = ""

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $page) {
                OnboardingWelcomePage().tag(0)
                OnboardingMetricsPage().tag(1)
                OnboardingProfilePage(name: $name, market: $market).tag(2)
                OnboardingNotificationsPage().tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    ForEach(0..<4, id: \.self) { i in
                        Circle()
                            .fill(i == page ? Color.primary : Color.secondary.opacity(0.35))
                            .frame(width: 8, height: 8)
                    }
                }

                HStack {
                    if page > 0 {
                        Button("Back") { withAnimation { page -= 1 } }
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button(page < 3 ? "Next" : "Get Started") {
                        if page < 3 { withAnimation { page += 1 } }
                        else { complete() }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
    }

    private func complete() {
        settings.driverName = name
        settings.market = market
        settings.onboardingComplete = true
    }
}
