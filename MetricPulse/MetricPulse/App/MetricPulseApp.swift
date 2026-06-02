import SwiftUI
import SwiftData

@main
struct MetricPulseApp: App {
    @State private var settings = AppSettings.shared
    let container: ModelContainer

    init() {
        let schema = Schema([MetricLog.self, TierConfig.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            let c = try ModelContainer(for: schema, configurations: [config])
            let ctx = c.mainContext
            if (try? ctx.fetchCount(FetchDescriptor<TierConfig>())) == 0 {
                TierConfig.defaults.forEach { ctx.insert($0) }
                try? ctx.save()
            }
            container = c
        } catch {
            fatalError("ModelContainer failed: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(settings)
        }
        .modelContainer(container)
    }
}

private struct RootView: View {
    @Environment(AppSettings.self) private var settings

    var body: some View {
        if settings.onboardingComplete {
            MainTabView()
        } else {
            OnboardingView()
        }
    }
}
