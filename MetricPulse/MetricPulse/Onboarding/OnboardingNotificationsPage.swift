import SwiftUI

struct OnboardingNotificationsPage: View {
    @State private var permission = NotificationPermission()

    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 64))
                .foregroundStyle(.yellow)

            VStack(spacing: 6) {
                Text("Stay on Track").font(.title2.bold())
                Text("Get notified when a strong shift is about to age out of your window.")
                    .font(.subheadline).foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            VStack(spacing: 8) {
                MockNotif(title: "Shift Aging Out",
                          message: "A strong OCR/OTM shift expires tomorrow. Log a shift to compensate.")
                MockNotif(title: "Metrics Check",
                          message: "OCR 88% — below Premier. 2 perfect shifts gets you there.")
            }
            .padding(.horizontal, 20)

            Group {
                switch permission.status {
                case .authorized:
                    Label("Notifications enabled", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                case .denied:
                    Text("Notifications blocked — enable in Settings")
                        .font(.caption).foregroundStyle(.secondary)
                default:
                    Button("Enable Notifications") {
                        Task { await permission.request() }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }

            Spacer()
        }
        .task { await permission.refresh() }
    }
}

private struct MockNotif: View {
    let title: String
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(.yellow)
                .frame(width: 36, height: 36)
                .overlay { Image(systemName: "chart.bar.fill").foregroundStyle(.black) }
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline.bold())
                Text(message).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
